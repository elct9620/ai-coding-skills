---
name: inspect
description: Prepare for what you have noticed or mean to take on next — reading what is there now, holding it against the spec and against what you have said, surfacing gaps in style consistency, test quality, and architectural alignment along the way — then converging through clarification into the work list for this round. Read-only — it does not change code, and an item stays out of the work list while anything about it is still ambiguous.
argument-hint: [path|module|--staged|intent] [--deep]
# --deep looks harder for what the user cannot see; without it, leads are reported unverified
allowed-tools: Read, Grep, Glob, Bash(git status:*), Bash(git log:*), Bash(git diff:*), Bash(git show:*), WebSearch, Skill(coding:design-forces), Skill(coding:testing), Skill(coding:refactoring), Skill(coding:principles), Skill(coding:design-patterns), Skill(coding:architecture), Skill(coding:schema), Skill(coding:security)
---

## Rule

The `<execute name="main">ARGUMENTS</execute>` is entry point for this command.

## How Deep to Read

You are preparing for something the user has named — what they have noticed, or what they mean to take on next. Being prepared means knowing what is there now, what it sits against, what is still undecided, and what this round should therefore take on. Holding the spec, the code, and the user's understanding against each other is how that readiness gets tested; it is not a survey to be completed for its own sake.

How much to read follows from that. Stop when reading one more file would no longer change what the work list holds or the order it should be taken in — past that point you are auditing the system rather than preparing for the work. This runs before the work starts and the clarification that follows keeps filling it in, so a pass that stops early and says where it stopped serves better than one that tries to be exhaustive.

Anything you would have to trace further to be sure of becomes a **lead** — its location, the question it raises, and why it might matter — recorded rather than chased. Holding a lead costs one line; chasing it costs the run. Ambiguity keeps an item out of the work list anyway, so digging until it resolves buys nothing here.

What licenses opening a file is a question it answers that a search cannot. So name the question first — *is this how the codebase everywhere else acquires a collaborator?* — and put it to whatever search the environment offers: a pattern across the tree, a file listing, a history query. A search answers across many files without opening one; open a file only when its answer has to be read in context, and when the file is long, search inside it and read the range that answers. A file you cannot attach a question to stays closed, whatever its size — the cheapest files to open are usually the ones with nothing to say.

Every conclusion is stated at the strength of the evidence behind it. Reading is not proof, so leads stay marked unverified until something traces them. A search is weaker still: it shows where a pattern matches, not what a match means in context nor that nothing else matches — *elsewhere the codebase injects its collaborators*, never *this is the only place that does not*. Weakest of all is anything you would have to run or evaluate to know — what a range expands to, where a boundary falls, what an expression computes — which stays unconfirmed however plainly it reads, because this command reads rather than runs. Certifying a broken promise as kept is worse than missing it: a miss leaves the doubt alive, a false all-clear ends it.

`--deep` says the user cannot see the thing themselves and is asking you to look harder — for what they have forgotten or overlooked, not only for proof of what is already listed. So it spends effort in two directions: tracing each lead until it can be confirmed or dropped, and taking every promise the spec makes about what is in scope to see whether it holds — following a promise to wherever the code that keeps it lives, because a promise broken outside the diff is exactly what someone cannot see from where they stand. What stays out is code no promise reaches: another area's shape or style is an audit, not preparation.

## Lenses

`coding:testing` and `coding:principles` are always active; every change has a test surface and a style surface. The rest activate only when the scope actually contains what they read for, so an unused lens costs nothing:

| Skill                    | Activates when the scope contains                                              |
|--------------------------|--------------------------------------------------------------------------------|
| `coding:refactoring`     | code smells or structural issues worth refactoring                             |
| `coding:design-patterns` | patterns that may be misused or missing                                        |
| `coding:architecture`    | crossings of architectural layers, dependency direction, or the recorded structure |
| `coding:schema`          | database schemas, API contracts, or data serialization                         |
| `coding:security`        | user input, auth, secrets, or trust boundaries                                  |

Language-specific skills are not listed here; check available skills before deciding.

## The Report

Whoever reads this is deciding what the round takes on, and that decision needs the whole shape first — how many findings, how bad, how well backed — before any one of them is worth reading closely. So the shape comes first and the reasoning follows it, rather than leaving the reader to assemble the shape out of the reasoning.

Most of what a finding carries is the same every time: where it is, how severe, what backs it, and a line saying what it is. That part sits well in a row. What differs is the reasoning that makes a claim non-obvious — the coupling that makes a fix larger than it looks, the counter-evidence that keeps a rule from being overdrawn — and that is what the prose beneath the row is for. State a finding in full once and refer to it by id after, so the work list and the ambiguities stay short.

Two or three sentences is usually the whole of that prose. This report opens a round of clarification rather than closing it, so what is easy to reach from the row is better left for the reader to reach, and a finding whose shape genuinely turns on its reasoning is where the extra sentences should go instead. Keep the sentence that would change what the reader does; drop the one that confirms what the row already told them. An item under Still ambiguous is sized the same way — the question, and what its answer would change.

This shape usually serves:

```markdown
# /inspect [--deep] — <what was inspected>

Scope: … · Spec: … · Lenses: …
Stopped at: … · Searched but never opened: …

| Pair | Verdict |
|---|---|
| Spec ↔ Code | 4 promises, 1 kept — F1 F2 F6 |
| Code ↔ You | silent — you have said nothing this session |
| Spec ↔ You | silent — same reason |

| # | Sev | Evidence | Where | Finding |
|---|---|---|---|---|
| F1 | High | traced | `links_controller.rb:19` | expired links answer 404; the spec promises 410 |
| F4 | Med | traced | `expiry_policy.rb:3` | a collaborator the main caller never uses |
| F6 | Med | unrun | `code_generator.rb:3` | `l` appears to survive in ALPHABET |

**Work list:** F1 → F2 → F5 ｜ **Held back:** F3, F9

## Spec against code
### F1 — expired links answer 404 · High · traced
<only what the row cannot carry>

## What makes agreement hard to keep
### F4 — …

## Still ambiguous — held out of the work list
<each in full: what is unsettled, and what its resolution would change>
```

The Evidence column is where the ladder above lands. Every finding names what backs it, so a row with nothing to put there is a finding that has not been established yet — which is easier to notice in a column than in a paragraph. A pair that agrees or stays silent is finished by its row; only a pair that diverges earns prose below.

Reach for an ASCII diagram when a finding runs through several places and prose would have to walk the reader through them in order — a request path that branches, a promise kept across three files. Where one line of prose says it, one line of prose is better.

Depart from this where the report is better for it: a pass with one finding needs no index, and a claim a cell would make sound firmer than its evidence belongs in prose.

## Definition

<function name="collect-scope">
    <description>Settle where to look before anything is read at depth. Scope comes from the target alone — depth is a separate axis.</description>
    <parameter name="target" type="string" description="A path, module, --staged flag, or a sentence naming what the user wants confirmed." required="false"/>
    <step>1. whatever place the target names is the scope, be it source, notes, a record of earlier rounds, or a scratch directory: `--staged` → `git diff --staged`; a path → `git diff HEAD -- $target`, or what stands under it when it carries no pending changes; empty → `git show HEAD`</step>
    <step>2. a sentence naming what the user wants confirmed usually carries its own scope: the places it names are the scope, what it tells you to read first is read first, and what it already decides is not reopened, since deciding is theirs; what it claims about how things are stays open to the evidence, and a claim the evidence contradicts is the finding the code-against-understanding section exists for. When it names no place, search out the parts it is about instead of falling back to the latest commit</step>
    <step>3. use ask question tool for whatever the target leaves unsettled, and only for that — asking what the user already answered wastes the round trip that reading the wrong scope was going to cost</step>
    <step>4. categorize what is in scope into source, test, config, docs</step>
    <return>the settled scope, with diff content when it came from changes</return>
</function>

<function name="read-leads">
    <description>Read the scope once through the active lenses and record what does not line up. Depth is bounded by the stopping rule in "How Deep to Read".</description>
    <parameter name="scope" type="object" description="The categorized scope." required="true"/>
    <step>1. activate the lenses the scope calls for and load them with Skill()</step>
    <step>2. read the scope itself, and whatever states the intended behaviour for it — a spec and roadmap where the project keeps them, otherwise the notes and records it keeps instead</step>
    <step>3. outside the scope, name the open question and search for its answer; read a neighbouring file only when the search cannot settle it, and only until it is settled</step>
    <step>4. record each thing that does not line up as a lead: location, the question it raises, severity, and the technique or skill that would address it (e.g. Extract Method via `coding:refactoring`)</step>
    <step>5. mark every lead unverified</step>
    <return>the leads, each unverified</return>
</function>

<function name="spend-depth">
    <description>Spend the effort --deep asks for: on the leads already held, and on what the default pass left unread. Only runs under --deep.</description>
    <parameter name="leads" type="list" description="The unverified leads." required="true"/>
    <parameter name="scope" type="object" description="The settled scope." required="true"/>
    <loop for="lead in $leads">
        <step>1. trace the lead from what it points at until it can be confirmed or dropped; a confirmed lead loses its unverified mark and carries the evidence — file and line — that confirmed it</step>
    </loop>
    <step>2. then check each promise the spec makes about the scope against what the code does, opening whatever keeps that promise even when it sits outside the diff. Whoever asked for depth cannot see it themselves, so the point is to find what they missed — but a promise is what makes a distant file worth opening, and code no promise reaches stays closed</step>
    <step>3. record anything new the same way read-leads does, and mark it verified only where it was traced rather than searched</step>
    <return>the confirmed leads, whatever the deeper reading turned up, and a one-line list of what was checked and found to be nothing</return>
</function>

<function name="report-alignment">
    <description>Organize the leads into the alignment report: whether the spec, the code, and the user's understanding agree; what makes agreement hard to keep; the work list for this round; and whatever is still ambiguous. Ambiguity keeps an item out of the work list.</description>
    <parameter name="leads" type="list" description="The leads, verified or not." required="true"/>
    <step>1. merge the leads and deduplicate what overlaps across lenses, then index them as "The Report" lays out</step>
    <step>2. give each pair its verdict: spec against code, code against the user's understanding, spec against the user's understanding. You are none of the three — the spec and the code can be read, but the user's understanding is knowable only from what they have said (this inspection's intent, earlier conversation, a work list they confirmed), so when they have said nothing that side is silent rather than spoken for. An empty result is stated, never argued: a blank defended at length reads as a blank in doubt. whatever states intended behaviour carries the spec side — a spec document where one exists, otherwise the notes or records the project keeps it in — and evidence that crosses it belongs here even when it surfaced while reading code</step>
    <step>3. report what makes agreement hard to keep: behaviour no test can pin down, code that contradicts its own naming or comments, conventions that cost a reader effort. This is your reading of the code rather than anyone's stated position, which is why it sits apart from the three pairs. This command reads rather than runs, so judge coverage by reading and note where that leaves a result unconfirmed — what you could not execute is a limit of the inspection, not a fault in the code. What was searched but never opened is named with the scope, since the reader can only tell where this list stops once the unread parts are stated</step>
    <step>4. draw the work list for this round from the sections above, ordering within it by severity</step>
    <step>5. list separately whatever is still ambiguous — an item whose scope, cause, or desired outcome is unsettled — and hold it out of the work list until it resolves, along with any work whose shape would change with the resolution. Work that merely stands near an unsettled question is not held: a finding with one clear fix keeps its place at its own severity however much is unsettled around it. Write "none" when nothing is ambiguous</step>
    <return>the alignment report, the work list for this round, and the ambiguities held back from it</return>
</function>

<procedure name="main">
    <parameter name="target" type="string" description="A path, module, --staged flag, or a sentence naming what the user wants confirmed." required="false"/>
    <parameter name="deep" type="boolean" description="When true, verify each lead with evidence instead of reporting it unverified." required="false"/>
    <step>1. <execute name="collect-scope" target="$target"/></step>
    <step>2. <execute name="read-leads" scope="$scope"/></step>
    <condition if="$deep">
        <step>3. <execute name="spend-depth" leads="$leads" scope="$scope"/></step>
    </condition>
    <step>4. <execute name="report-alignment" leads="$leads"/></step>
    <condition if="a work list confirmed in an earlier round is present in this context">
        <step>5. quote that work list verbatim and compare this round's changes against it, reporting whether the work stayed inside it. Nobody is waiting to answer here, so ask nothing: drift or a fresh ambiguity stops the run and is reported for the user to resolve</step>
    </condition>
    <condition if="no confirmed work list exists — this is the opening round">
        <step>6. present the alignment report, the work list, and the ambiguities, then invite the user to confirm it or ask further — a side left silent for want of anything they have said is the natural thing for them to answer first. Each answer resolves ambiguities and redraws the list; the user decides when it is settled enough to run `/write` or `/refactor`</step>
        <condition if="leads remain unverified and not $deep">
            <step>7. add one line offering `/inspect [same target] --deep` to trace them</step>
        </condition>
    </condition>
    <return>the alignment report with the work list for this round, or the drift report when a confirmed list already exists</return>
</procedure>

## Task

<execute name="main">$ARGUMENTS</execute>
