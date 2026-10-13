# Forces

Open in planning, when a structural choice is still undecided. The output is a memo the user decides on; the direction they confirm goes into the work list's References.

## Six Forces

Check every force; "does not apply" is a valid answer.

| Force | Asks |
|---|---|
| Delivery pressure | Can a deeper investment pay back in time? |
| Rule complexity | Are the rules thick enough to model explicitly? |
| Change rate | Is flexibility now cheaper than rework later? |
| Team fragmentation | Will several roles describe this in their own words? |
| Blast radius | What breaks if this is wrong, and how visibly? |
| Code maturity | Does the surrounding code need preparing first? |

Read signals before asking — manifests, `git log` churn, contributors, tests, spec wording. Ask at most three questions.

## Option Space

Give four to six options grounded in this codebase, including:

- The framework's idiomatic option, in its own vocabulary.
- A "do less" option: framework default, defer with a trigger, or a spike.
- A meta-level option where plausible: a scaffold, an internal library, a workflow change.

## Memo

One screen: context, recorded patterns considered, forces with evidence, options with trade-offs, a soft recommendation with the condition that would change it, and one or two questions worth confirming. When a recorded pattern still fits, confirm it and stop.
