require "minitest/autorun"
require "ledger_sync/matcher"

class MatcherTest < Minitest::Test
  def test_files_a_coffee_purchase_under_food
    assert_equal "Expenses:Food:Coffee -4.5", LedgerSync::Matcher.new.entry_for("memo" => "COFFEE SHOP", "amount" => "-4.5")
  end

  def test_files_an_unknown_memo_under_unknown
    assert_equal "Expenses:Unknown -9", LedgerSync::Matcher.new.entry_for("memo" => "MISC", "amount" => "-9")
  end
end
