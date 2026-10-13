module LedgerSync
  class Matcher
    RULES = { /COFFEE/i => "Expenses:Food:Coffee", /SALARY/i => "Income:Salary" }.freeze

    def entry_for(row)
      account = RULES.find { |pattern, _| row["memo"] =~ pattern }&.last || "Expenses:Unknown"
      "#{account} #{row['amount']}"
    end
  end
end
