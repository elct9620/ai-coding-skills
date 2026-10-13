require "minitest/autorun"
require_relative "../lib/invoice"

class InvoiceTest < Minitest::Test
  def test_sums_the_lines_into_the_total_due
    assert_equal "Total due: $12.50", Invoice.new([{ cents: 1000 }, { cents: 250 }]).summary
  end
end
