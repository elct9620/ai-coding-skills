# Testing

The test types, AAA, and test doubles are known. This file holds the stances that make a suite a net rather than a green light.

## Integration first

Prove components work together, then add unit tests only for edges integration cannot reach. A module with no integration path either serves no real need or is missing that path.

## Proving the net

Green proves the code passes its tests, not that the tests would notice a break. Break a promise from the specs on purpose — 410 becomes 404, a guard disappears — and run the suite.

| Baseline | With the break | After restoring | Reading |
|---|---|---|---|
| Green | Red | Diff matches | The net holds for that promise |
| Green | Green | Diff matches | Nothing watches it — the missing test is owed |
| Red | — | — | Make the baseline green first |
| Green | Red | Diff differs | Restoration failed — stop and say so |

The break comes from a promise, not from the nearest operator. When the scope carries no promise worth breaking, report the net unverified rather than inventing one. Take the diff before the break and after restoring; a green suite alone does not prove the text returned.

## Journey integrity

An E2E test that stands for a user journey has three properties:

| Property | Holds when |
|---|---|
| Whole path | It enters where the user enters and passes every real step, with no fabricated shortcut |
| Goal outcome | It asserts what the user walks away with, not a waypoint like a redirect |
| One unbroken test | Each critical journey in the specs has one test from start to finish, including its prerequisite branches |

## Doubt becomes a test

When you want to try a one-liner to see what the code or an API does, write that assumption as an assertion and run the test. The assertion stays as a net; shell output disappears.

| Situation | Instead |
|---|---|
| No test environment exists | A one-off `-e` is acceptable |
| Third-party behavior | Read its official documentation |
| Environment checks (`node -v`, `git log`) | Outside this rule |

## Boundaries and doubles

- Prefer real over fake, fake over stub, stub over mock. Use the real service when the test environment provides it.
- Assert the project's outcome at a boundary, not the library's behavior: the repository returns the right business object, not the ORM's SQL.
- In legacy code, characterization tests pin current behavior. Assert the semantic contract — timing, committed side effects, error model — not only return values.

## Naming

Name a test by behavior: `should <expected behavior> when <condition>`. Leave AAA implicit for one-line assertions.
