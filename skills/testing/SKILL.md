---
name: testing
description: Write tests using TDD (Red-Green-Refactor) and AAA pattern. Use for every new feature, behavior change, or bug fix. Covers unit, integration, and E2E test selection.
---

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

> Ensure components work together first, then verify individual component details

| Scenario | Action |
|----------|--------|
| Starting new feature | Write integration/E2E test first |
| Integration test passes | Add unit tests only for uncovered edge cases |
| Edge case not covered by integration | Add unit test for specific case |
| Component works alone but fails together | Missing integration test coverage |

### TDD Cycle (Red-Green-Refactor)

```
┌─────────┐
│   RED   │ ← Write failing test
└────┬────┘
     ↓
┌─────────┐
│  GREEN  │ ← Write minimal code to pass
└────┬────┘
     ↓
┌─────────┐
│REFACTOR │ ← Improve code, keep tests green
└────┬────┘
     ↓
   (repeat)
```

### Testing Pyramid

```
        ╱╲
       ╱  ╲
      ╱ E2E╲        Few, slow, high confidence
     ╱──────╲
    ╱Integration╲   Some, medium speed
   ╱────────────╲
  ╱    Unit       ╲  Many, fast, focused
 ╱─────────────────╲
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

### After Writing Tests

| Criterion | Pass | Fail |
|-----------|------|------|
| All passing | All tests pass | Failing tests |
| Adequate coverage | Meaningful coverage achieved | Critical paths untested |
| Maintainability | Tests easy to maintain | Fragile or complex tests |
| No test smells | Clean test code | Test code smells present |

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

## Mocking Decision Table

| Target | Mock? | Reason |
|--------|-------|--------|
| External services (APIs, DB) | Yes | Isolation, speed |
| Time/dates | Yes | Determinism |
| Random values | Yes | Reproducibility |
| File system (unit tests) | Yes | Speed, isolation |
| The thing being tested | No | Defeats purpose |
| Value objects | No | Simple, no side effects |
| Simple collaborators | No | Over-isolation |
| Everything | No | Over-mocking hides bugs |
