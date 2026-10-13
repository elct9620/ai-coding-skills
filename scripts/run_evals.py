#!/usr/bin/env python3
"""Run a skill's evals as headless main-agent sessions and grade them.

Each run builds its fixture repository with the eval's setup script, runs
`claude -p` inside it with one plugin directory, and stores the transcript,
the final response, and the repository's changes under
`skills/<skill>-workspace/iteration-<n>/`. Grading asks a separate session
to judge every expectation and writes `grading.json` with the `summary`
block the skill-creator benchmark reads.
"""

import argparse
import json
import shutil
import subprocess
import sys
import tempfile
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
PLUGINS = {
    "with_skill": ROOT,
    "old_skill": ROOT / "evals-workspace" / "baseline",
    "without_skill": ROOT / "evals-workspace" / "baseline",
}
ALLOWED_TOOLS = ",".join([
    "Read", "Grep", "Glob", "Edit", "Write", "Skill", "TaskCreate", "TaskUpdate",
    "WebSearch", "WebFetch",
    "Bash(ruby:*)", "Bash(rake:*)", "Bash(ls:*)", "Bash(cat:*)", "Bash(wc:*)",
    "Bash(git status:*)", "Bash(git log:*)", "Bash(git diff:*)", "Bash(git show:*)",
    "Bash(git add:*)", "Bash(git commit:*)", "Bash(git stash:*)", "Bash(git checkout:*)",
])
RUN_TIMEOUT = 1200


def run_one(skill_dir, eval_def, config, run_index, iteration_dir, scratch):
    run_dir = iteration_dir / f"eval-{eval_def['name']}" / config / f"run-{run_index}"
    outputs = run_dir / "outputs"
    if (outputs / "response.md").exists():
        return run_dir
    outputs.mkdir(parents=True, exist_ok=True)
    repo = Path(tempfile.mkdtemp(prefix=f"{eval_def['name']}-{config}-", dir=scratch)) / "repo"
    repo.mkdir()
    subprocess.run(["bash", str(skill_dir / eval_def["setup"]), str(repo)], check=True,
                   capture_output=True)
    prompt = eval_def["prompt"] if config == "with_skill" else eval_def.get("baseline_prompt", eval_def["prompt"])
    cmd = ["claude", "-p", prompt, "--plugin-dir", str(PLUGINS[config]),
           "--output-format", "stream-json", "--verbose", "--allowedTools", ALLOWED_TOOLS]
    with open(run_dir / "transcript.jsonl", "w") as transcript:
        proc = subprocess.run(cmd, cwd=repo, stdout=transcript, stderr=subprocess.PIPE,
                              text=True, timeout=RUN_TIMEOUT)
    result = {}
    for line in open(run_dir / "transcript.jsonl"):
        try:
            event = json.loads(line)
        except json.JSONDecodeError:
            continue
        if event.get("type") == "result":
            result = event
    (outputs / "response.md").write_text(result.get("result", "") or proc.stderr)
    (outputs / "changes.diff").write_text(subprocess.run(
        ["git", "add", "-A", "-n", "."], cwd=repo, capture_output=True, text=True).stdout
        + subprocess.run(["git", "diff", "HEAD"], cwd=repo, capture_output=True, text=True).stdout
        + "\n".join(f"\n=== new file: {p}\n{(repo / p).read_text(errors='replace')}"
                    for p in subprocess.run(["git", "ls-files", "--others", "--exclude-standard"],
                                            cwd=repo, capture_output=True, text=True).stdout.split()))
    (outputs / "git-log.txt").write_text(subprocess.run(
        ["git", "log", "--stat", "--format=%h %s"], cwd=repo, capture_output=True, text=True).stdout)
    usage = result.get("usage", {})
    (run_dir / "timing.json").write_text(json.dumps({
        "total_tokens": sum(v for k, v in usage.items() if k.endswith("tokens") and isinstance(v, int)),
        "duration_ms": result.get("duration_ms", 0),
        "total_duration_seconds": round(result.get("duration_ms", 0) / 1000, 1),
    }, indent=2))
    shutil.copytree(repo, outputs / "repo", ignore=shutil.ignore_patterns(".git"), dirs_exist_ok=True)
    return run_dir


def skill_reads(run_dir):
    reads = []
    for line in open(run_dir / "transcript.jsonl"):
        try:
            event = json.loads(line)
        except json.JSONDecodeError:
            continue
        for block in (event.get("message") or {}).get("content", []) if isinstance(event.get("message"), dict) else []:
            if isinstance(block, dict) and block.get("type") == "tool_use":
                name, args = block.get("name"), block.get("input", {})
                if name in ("Read", "Skill"):
                    reads.append(f"{name}: {args.get('file_path') or args.get('skill')}")
                elif name == "Bash" and "references/" in args.get("command", ""):
                    reads.append(f"Bash: {args['command'][:200]}")
    return reads


GRADER_PROMPT = """You grade one eval run. Judge each expectation strictly against the evidence below and the files in this directory.
Return only JSON: {{"expectations": [{{"text": <expectation>, "passed": <bool>, "evidence": <one sentence quoting or citing what decided it>}}]}}

Expectations:
{expectations}

Final response of the run is in outputs/response.md. Repository changes are in outputs/changes.diff, commits in outputs/git-log.txt, the resulting repository in outputs/repo/; run its tests with `ruby -Ioutputs/repo/lib <test file>` when an expectation needs them.
Files and skills the run read: {reads}
"""


def grade(run_dir, eval_def):
    if (run_dir / "grading.json").exists():
        return
    expectations = eval_def["expectations"]
    prompt = GRADER_PROMPT.format(
        expectations="\n".join(f"- {e}" for e in expectations),
        reads="; ".join(skill_reads(run_dir)) or "none")
    proc = subprocess.run(["claude", "-p", prompt, "--output-format", "json",
                           "--allowedTools", "Read,Grep,Glob,Bash(ruby:*),Bash(ls:*)"],
                          cwd=run_dir, capture_output=True, text=True, timeout=600)
    text = json.loads(proc.stdout).get("result", "")
    start, end = text.find("{"), text.rfind("}")
    graded = json.loads(text[start:end + 1])["expectations"]
    passed = sum(1 for e in graded if e["passed"])
    (run_dir / "grading.json").write_text(json.dumps({
        "expectations": graded,
        "summary": {"pass_rate": round(passed / len(graded), 2), "passed": passed,
                    "failed": len(graded) - passed, "total": len(graded)},
    }, indent=2, ensure_ascii=False))


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("skill")
    parser.add_argument("--iteration", type=int, default=1)
    parser.add_argument("--runs", type=int, default=3)
    parser.add_argument("--parallel", type=int, default=4)
    parser.add_argument("--evals", nargs="*", help="eval names to run; all when omitted")
    parser.add_argument("--scratch", default=tempfile.gettempdir())
    args = parser.parse_args()

    skill_dir = ROOT / "skills" / args.skill
    spec = json.loads((skill_dir / "evals" / "evals.json").read_text())
    evals = [e for e in spec["evals"] if not args.evals or e["name"] in args.evals]
    iteration_dir = ROOT / "skills" / f"{args.skill}-workspace" / f"iteration-{args.iteration}"
    for e in evals:
        eval_dir = iteration_dir / f"eval-{e['name']}"
        eval_dir.mkdir(parents=True, exist_ok=True)
        (eval_dir / "eval_metadata.json").write_text(json.dumps(
            {"eval_id": e["id"], "eval_name": e["name"], "prompt": e["prompt"],
             "assertions": e["expectations"]}, indent=2, ensure_ascii=False))
    jobs = [(e, c, r) for e in evals for c in e.get("configs", ["with_skill", "old_skill"])
            for r in range(1, args.runs + 1)]

    with ThreadPoolExecutor(args.parallel) as pool:
        futures = {pool.submit(run_one, skill_dir, e, c, r, iteration_dir, args.scratch): (e, c, r)
                   for e, c, r in jobs}
        for future, (e, c, r) in futures.items():
            try:
                run_dir = future.result()
                grade(run_dir, e)
                print(f"done {e['name']} {c} run-{r}", flush=True)
            except Exception as error:  # report and keep the other runs going
                print(f"failed {e['name']} {c} run-{r}: {error}", file=sys.stderr, flush=True)


if __name__ == "__main__":
    main()
