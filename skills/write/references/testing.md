# Testing

## Stances

- Integration first; unit tests only for edges integration cannot reach.
- At a boundary, assert the project's outcome, not the library's behavior.
- A characterization test asserts the semantic contract, not only return values.
- Doubt about behavior becomes an assertion in a test. A one-off `-e` is fine only where no test environment exists.

## Proving the Net

Break a promise from the specs on purpose — 410 becomes 404, a guard disappears — and run the suite.

| Baseline | With the break | After restoring | Reading |
|---|---|---|---|
| Green | Red | Diff matches | Held |
| Green | Green | Diff matches | Missing — a test is owed |
| Red | — | — | Make the baseline green first |
| Green | Red | Diff differs | Restoration failed — report and hold the item |

The break comes from a promise, not the nearest operator. With no promise worth breaking, the net is Unverified.

## Journey Integrity

An end-to-end test for a user journey enters where the user enters, passes every real step without fabricated shortcuts, and asserts what the user walks away with. Each critical journey in the specs has one such test.
