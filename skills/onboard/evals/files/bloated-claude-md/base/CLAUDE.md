# CLAUDE.md

This file provides guidance to Claude Code when working with code in this repository.

## Commands

```bash
bundle install
bundle exec rake            # run the tests
bundle exec rake test       # run the tests
bundle exec rake import     # import the bank CSV files under data/
bundle exec rake balance    # print the balance of every account
ruby -Ilib test/matcher_test.rb  # one test file
```

## Code Style

- Use two spaces for indentation.
- Use snake_case for methods and variables.
- Use CamelCase for classes and modules.
- Put each class in its own file under lib/ledger_sync/.
- Wrap every class in the LedgerSync module.
- Use keyword arguments for optional parameters.
- Prefer `each` over `for` loops.
- Use `require_relative` inside lib/.
- Write tests with Minitest.
- Name test methods with `test_`.
- Use `assert_equal` with the expected value first.
- Freeze constant hashes.

## Project Structure

- `lib/ledger_sync/app.rb` — the App class
- `lib/ledger_sync/bank_csv.rb` — the BankCsv class
- `lib/ledger_sync/ledger.rb` — the Ledger class
- `lib/ledger_sync/matcher.rb` — the Matcher class
- `lib/ledger_sync/importer.rb` — the Importer class
- `test/` — the tests
- `docs/` — documentation

## How the Import Works

1. `BankCsv#rows` reads every CSV file under `data/`, sorted by file name.
2. Each row becomes a Hash keyed by the CSV headers.
3. `Matcher#entry_for` finds the first rule whose pattern matches the memo.
4. A memo without a rule goes to `Expenses:Unknown`.
5. `Ledger#append` writes the entry at the end of `ledger.beancount`.
6. `Ledger#balances` sums the amounts per account.

## Notes

- The ledger file is appended to, never rewritten, so a mistake is fixed by a new entry.
- Matching rules are added only after a memo shows up twice; see docs/matching.md.
- Do not commit anything under `data/`; it holds real bank exports.
- Always run the tests before committing.
- Write commit messages in English.
- Keep methods short.
- Avoid global state.
- Handle errors gracefully.
- Write clean, readable code.
- Document public methods.
- Keep dependencies minimal.
- Prefer composition over inheritance.
