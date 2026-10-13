# Matching Rules

`Matcher::RULES` maps a bank memo pattern to a ledger account. A memo that
matches no rule goes to `Expenses:Unknown`, so a person reviews it before
the month closes. Add a rule only after the same memo has shown up twice.
