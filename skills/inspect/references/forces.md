# Forces

Open in planning, when a structural choice is still undecided. The output is a memo the user decides on; the direction they confirm goes into the work list's References.

## Start From Intent

Ask what the user intends, where the change lands, and who uses the result. Each force rests on a reason; check the reason holds for this intent before weighing the force. "Not needed yet" rests on unused code having a cost. For an SDK whose users sit outside the project, ask instead whether it is useful to them.

## Six Forces

Check every force; "does not apply" is a valid answer.

| Force | Asks | Rests on |
|---|---|---|
| Delivery pressure | Can a deeper investment pay back in time? | A deadline the investment competes with |
| Rule complexity | Are the rules thick enough to model explicitly? | Rules that interact, not just validate |
| Change rate | Is flexibility now cheaper than rework later? | Change that is likely and locatable |
| Team fragmentation | Will several roles describe this in their own words? | More than one group reading and changing it |
| Blast radius | What breaks if this is wrong, and how visibly? | Failure that reaches users or data |
| Code maturity | Does the surrounding code need preparing first? | Code that resists the change |

Read signals before asking — manifests, `git log` churn, contributors, tests, spec wording. Ask at most three questions.

## Option Space

Give four to six options grounded in this codebase, including:

- The framework's idiomatic option, in its own vocabulary.
- A "do less" option: framework default, defer with a trigger, or a spike.
- A meta-level option where plausible: a scaffold, an internal library, a workflow change.

## Memo

One screen: intent, recorded patterns considered, forces with evidence, options with trade-offs, a soft recommendation with the condition that would change it, and one or two questions worth confirming. When a recorded pattern still fits, confirm it and stop.
