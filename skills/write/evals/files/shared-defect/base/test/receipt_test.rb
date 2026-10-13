require "minitest/autorun"
require_relative "../lib/receipt"

class ReceiptTest < Minitest::Test
  def test_shows_the_amount_paid
    assert_equal "Paid: $3.25", Receipt.new(325).summary
  end
end
