---
name: testing
description: Write tests using TDD (Red-Green-Refactor) and AAA pattern. Use for every new feature, behavior change, or bug fix. Covers unit, integration, and E2E test selection. Make sure to use this skill whenever the user asks to add tests, fix a bug (tests should come first), implement a feature with test coverage, or asks about what kind of tests to write — even for small one-line changes or trivial-looking fixes.
---

## Related Skills

- Found a code smell while writing tests? → Use **refactoring** to fix it first
- Need to design the class structure before testing? → Use **design-patterns** or **principles**
- Adding a database migration or API endpoint? → Use **schema** alongside testing

## Applicability Rubric

| Condition | Pass | Fail |
|-----------|------|------|
| New feature implementation | Adding new functionality | No new behavior |
| Behavior change | Modifying existing behavior | No behavior change |
| Bug fix | Fixing a defect | Non-bug change |
| Pre-refactoring | Ensuring tests exist before refactor | Tests already sufficient |

**Apply when**: Any condition passes

## Core Principles

### Integration-First Philosophy

> Ensure components work together first, then verify individual component details.
> Unit tests are supplementary — only add them for edge cases that integration tests cannot practically cover.

| Scenario | Action |
|----------|--------|
| Starting new feature | Write integration/E2E test first |
| Integration test passes | Add unit tests only for uncovered edge cases |
| Edge case not covered by integration | Add unit test for specific case |
| Component works alone but fails together | Missing integration test coverage |
| Module has no integration test path | Verify the module serves a real user need; if it does, add the missing integration path |

### TDD Cycle (Red-Green-Refactor)

```
┌─────────┐
│   RED   │ ← Write failing test → confirm: "Test fails because [reason]"
└────┬────┘
     ↓
┌─────────┐
│  GREEN  │ ← Write minimal code → confirm: "All tests now pass"
└────┬────┘
     ↓
┌─────────┐
│REFACTOR │ ← Improve code → confirm: "Tests still pass after refactoring"
└────┬────┘
     ↓
   (repeat)
```

Each phase transition requires an explicit confirmation statement. Skipping the confirmation — especially at GREEN — breaks the feedback loop that makes TDD valuable. Without "all tests pass," you cannot be sure the fix actually works.

### Testing Trophy

> Inspired by Kent C. Dodds' Testing Trophy — integration tests provide the best balance of confidence and cost. This replaces the traditional pyramid to reflect an integration-first approach.

```
        ╱╲
       ╱  ╲
      ╱ E2E╲          Few, slow, highest confidence
     ╱──────╲
    ╱          ╲
   ╱ Integration╲     Most tests live here
  ╱──────────────╲
  ╲    Unit      ╱     Few, only for edge cases
   ╲────────────╱
```

## Test Types

| Type | Scope | Speed | Use For |
|------|-------|-------|---------|
| Unit | Single function/class | Fast | Logic, calculations |
| Integration | Multiple components | Medium | Component interaction |
| E2E | Full system | Slow | Critical user flows |

### Test Type Selection

| Testing Target | Unit | Integration | E2E |
|----------------|------|-------------|-----|
| Pure functions | ✓ | | |
| Business logic | ✓ | | |
| Edge cases | ✓ | | |
| Error handling | ✓ | | |
| Database operations | | ✓ | |
| API endpoints | | ✓ | |
| Service interactions | | ✓ | |
| External dependencies | | ✓ | |
| Critical user journeys | | | ✓ |
| Smoke tests | | | ✓ |
| Regression prevention | | | ✓ |

## TDD Phase Discipline

Each TDD phase must be explicitly confirmed before moving to the next:

| Phase | Action | Confirmation |
|-------|--------|-------------|
| **RED** | Write failing test | State: "Test fails because [reason]" |
| **GREEN** | Write minimal fix | State: "All tests now pass" |
| **REFACTOR** | Improve code | State: "Tests still pass after refactoring" |

The GREEN phase is not just writing the fix — you must confirm that tests pass. Without this confirmation, the cycle is incomplete and regressions can slip through unnoticed.

## Verification Discipline

When you are about to implement a feature and think *"let me try a one-liner to see if this approach works"* or *"let me check what this API returns for the edge case first"* — stop. That uncertainty is a missing test case. Encode the assumption as an assertion in the test file, run the test, and let it answer.

### Why ad-hoc execution is the wrong oracle

| Problem | Consequence |
|---------|-------------|
| Bypasses the test environment | Results don't reflect the real module graph, env vars, or fixtures |
| Requires shell authorization | Every invocation interrupts the user to approve arbitrary execution |
| Leaves no regression net | The knowledge evaporates the moment the shell exits |

### The right reflex

> **Wrong:** Run `node -e "..."` / `ruby -e "..."` / `python -c "..."` to check behavior → then write code based on the result.
>
> **Right:** Add a test that asserts the expected behavior → run the test → iterate until it passes.

The assertions stay in the repo as regression coverage; the shell output does not.

### Exceptions

| Situation | What applies instead |
|-----------|----------------------|
| Project has no test environment | `-e` is acceptable — nothing to encode the assumption into |
| Third-party library behavior | Read the official docs; don't reverse-engineer. See also **Boundary Testing** for where library behavior belongs in tests |
| Non-code environment checks (`node -v`, `git log`, `which ...`) | Outside this rule — use the appropriate tool freely |

The dividing line: if the thing you want to verify is about your code's correctness, it belongs in a test.

## Working with Legacy Code (No Existing Tests)

When facing code with zero test coverage, testing requires a different entry strategy than greenfield TDD.

### Characterization Tests

A characterization test captures **what the code currently does**, not what it should do. The goal is to lock down existing behavior so you can refactor safely.

```ruby
# Step 1: Call the code and observe what happens
test "characterize: payment processor charges card with 2.9% fee" do
  processor = PaymentProcessor.new
  result = processor.charge(card: valid_card, amount: 100.0)
  # Record whatever the code actually returns
  assert_equal 102.90, result.total_charged
  assert_equal "approved", result.status
end
```

### Dealing with Untestable Code

Legacy code often has barriers to testing. Common patterns and workarounds:

| Barrier | Symptom | Workaround |
|---------|---------|------------|
| Hard-coded dependency | `PaymentGateway.new` inside method | **Extract and Override**: subclass in test, override the method that creates the dependency |
| Global state | Class methods, singletons | **Inject the global**: pass it as a parameter, reset between tests |
| No dependency injection | Constructor creates all deps | **Introduce Seam**: extract a method for the dependency creation, override in test subclass |
| Side effects in constructor | Network calls, file I/O at init | **Wrap and isolate**: create a test-only subclass that skips the side effects |

### Legacy Code Testing Strategy

1. **Write characterization tests first** — capture current behavior with integration-level tests
2. **Identify seams** — find points where you can alter behavior without editing the code (subclass, extract method, wrap)
3. **Make the change** — add new feature or fix bug using TDD
4. **Verify no regressions** — all characterization tests still pass

## Test Structure (AAA Pattern)

```
test("should calculate total with discount", () => {
  // Arrange - Set up test data
  const cart = new Cart();
  cart.addItem({ price: 100 });

  // Act - Execute the behavior
  const total = cart.calculateTotal(0.1); // 10% discount

  // Assert - Verify the result
  expect(total).toBe(90);
});
```

For simple validation tests (e.g., `assert_raises`, single-expression assertions), the AAA structure may be implicit — forcing explicit comments on a one-liner adds noise rather than clarity. AAA is most valuable when the test has meaningful setup or multi-step actions.

## Completion Rubric

### Before Writing Tests

| Criterion | Pass | Fail |
|-----------|------|------|
| Requirement understanding | Requirements clear | Unclear what to test |
| Test case identification | Happy path, edge cases, errors identified | Missing test scenarios |
| Test type selection | Appropriate type chosen | Wrong test level |
| Environment setup | Test environment ready | Setup issues |

### Writing Tests

| Criterion | Pass | Fail |
|-----------|------|------|
| Descriptive naming | Name describes behavior | Name describes implementation |
| Single assertion | One assertion per test (when practical) | Multiple unrelated assertions |
| Independence | Tests have no shared state | Tests depend on each other |
| Determinism | Tests always produce same result | Flaky tests |

### Test Quality

| Criterion | Pass | Fail |
|-----------|------|------|
| Correct failure | Tests fail for right reason | False positives/negatives |
| Behavior focus | Tests behavior, not implementation | Tests internal details |
| Documentation value | Tests serve as documentation | Tests are cryptic |
| Fast feedback | Tests run quickly enough | Slow test suite |
| Boundary focus | Asserts project's business outcomes | Asserts third-party library behavior |

### After Writing Tests

| Criterion | Pass | Fail |
|-----------|------|------|
| All passing | All tests pass | Failing tests |
| Adequate coverage | Meaningful coverage achieved | Critical paths untested |
| Maintainability | Tests easy to maintain | Fragile or complex tests |
| No test smells | Clean test code | Test code smells present |
| No dead code coverage | All tested code has integration paths | Tests exist for unused code |

## Test Naming Convention

Pattern: `should [expected behavior] when [condition]`

Examples:
- `should return empty array when no items exist`
- `should throw error when input is invalid`
- `should calculate discount when coupon is applied`

## Common Test Smells

| Smell | Problem | Solution |
|-------|---------|----------|
| Flaky Test | Sometimes passes, sometimes fails | Remove randomness, fix timing issues |
| Slow Test | Takes too long to run | Mock external deps, use unit tests |
| Brittle Test | Breaks with unrelated changes | Test behavior, not implementation |
| Mystery Guest | Uses external data/files | Make test self-contained |
| Test Duplication | Same setup repeated | Use test fixtures/factories |
| Library Testing | Verifies third-party behavior instead of project code | Assert business outcomes at your boundary |
| Dead Code Testing | Unit tests cover code with no integration path | Remove tests and implementation together |

## Test Double Decision Table

Before choosing a test double, check whether the test environment already provides the real dependency or a faithful simulation. **Prefer real over fake, fake over stub, stub over mock** — the closer to production behavior, the more confidence the test provides.

### Environment-Aware Decision Flow

| Step | Question | If Yes | If No |
|------|----------|--------|-------|
| 1 | Test environment provides the real service? (e.g., Testcontainers, Docker Compose, in-memory DB) | **Use it directly** — no test double needed | Go to step 2 |
| 2 | A faithful simulation exists? (e.g., fake SMTP server, WireMock, SQLite for Postgres) | **Use the simulation** — closer to real behavior | Go to step 3 |
| 3 | The dependency is slow, non-deterministic, or has side effects? | **Stub or mock** at the boundary | Use the real dependency |

### When to Use Test Doubles

| Target | Double? | Reason |
|--------|---------|--------|
| DB with test container available | No | Real DB behavior catches schema/query issues |
| External API with simulation (WireMock, VCR) | Prefer simulation | Captures real response shapes and edge cases |
| External API with no simulation | Stub | Isolation, speed |
| Time/dates | Stub | Determinism |
| Random values | Stub | Reproducibility |
| File system (unit tests) | Stub | Speed, isolation |
| The thing being tested | No | Defeats purpose |
| Value objects | No | Simple, no side effects |
| Simple collaborators | No | Over-isolation |
| Everything | No | Over-mocking hides bugs |

## Boundary Testing

| Dependency | Pass (test your code) | Fail (test their code) |
|------------|----------------------|------------------------|
| ORM / Database | Repository returns correct business objects | ORM generates correct SQL |
| HTTP Client | Service handles response/error correctly | Client sends well-formed requests |
| Auth Library | Endpoint rejects unauthorized users | Token validation algorithm |
| Queue / Messaging | Handler processes message with correct outcome | Message serialization format |
| File Storage | Service returns file content or meaningful error | Storage SDK upload internals |
| Validator Library | Input rejected/accepted per business rules | Validator regex implementation |
