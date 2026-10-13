#!/usr/bin/env python3
"""Check whether a /goal evaluator judges completion correctly from a report.

Takes the final reports that `run_evals.py` stored, pairs each with the goal
template in README.md, and asks a small model whether the goal is met. The
truth comes from the run's own grading: a write round is met when its items
are done or held for the user and its tests pass; a round whose checking
report still carries unfixed drift is not met.
"""

import json
import re
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
MODEL = "claude-haiku-5-5"
JUDGE = """A /goal is running. The goal it checks is:

{goal}

The agent's latest output is:

<output>
{report}
</output>

Decide whether the goal is met by this output. Answer with MET or NOT MET on the first line, then one sentence saying why."""

# (skill, eval, truth from the run's grading.json)
CASES = [
    ("write", "held-decision",
     lambda passed: "MET" if all(passed[i] for i in (0, 1, 2, 3, 4)) else "NOT MET"),
    ("inspect", "drift-kinds", lambda passed: "NOT MET"),
]


def goal_template():
    readme = (ROOT / "README.md").read_text()
    return re.search(r"### Goal Template.*?```\n(.*?)```", readme, re.S).group(1).strip()


def judge(goal, report):
    proc = subprocess.run(["claude", "-p", JUDGE.format(goal=goal, report=report),
                           "--model", MODEL, "--output-format", "json", "--tools", ""],
                          capture_output=True, text=True, timeout=300)
    answer = json.loads(proc.stdout).get("result", "").strip()
    # The model sometimes echoes the instruction "MET or NOT MET" before answering.
    found = re.search(r"\b(NOT MET|MET)\b", re.sub(r"MET or NOT MET", "", answer, flags=re.I))
    return (found.group(1) if found else "UNCLEAR"), answer


def main():
    iteration = sys.argv[1] if len(sys.argv) > 1 else "1"
    trials = int(sys.argv[2]) if len(sys.argv) > 2 else 3
    goal = goal_template()
    out_dir = ROOT / "evals-workspace" / f"goal-judgment-{iteration}"
    out_dir.mkdir(parents=True, exist_ok=True)
    rows = []
    for skill, name, truth_of in CASES:
        eval_dir = ROOT / "skills" / f"{skill}-workspace" / f"iteration-{iteration}" / f"eval-{name}"
        for run in sorted(eval_dir.glob("*/run-*")):
            grading = json.loads((run / "grading.json").read_text())
            truth = truth_of([e["passed"] for e in grading["expectations"]])
            report = (run / "outputs" / "response.md").read_text()
            for trial in range(1, trials + 1):
                verdict, answer = judge(goal, report)
                rows.append({"eval": name, "config": run.parent.name, "run": run.name, "trial": trial,
                             "truth": truth, "verdict": verdict, "correct": verdict == truth,
                             "answer": answer})
                print(f"{name} {run.parent.name} {run.name} #{trial}: {verdict} (truth {truth})", flush=True)
    (out_dir / "judgments.json").write_text(json.dumps(rows, indent=2, ensure_ascii=False))
    for config in sorted({r["config"] for r in rows}):
        mine = [r for r in rows if r["config"] == config]
        print(f"{config}: {sum(r['correct'] for r in mine)}/{len(mine)} correct")


if __name__ == "__main__":
    main()
