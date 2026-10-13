require "minitest/autorun"
require_relative "../lib/pricing"

class PricingTest < Minitest::Test
  def test_adds_tax_and_takes_off_the_member_discount
    assert_in_delta 100.0, Pricing.new(tax_rate: 0.1).total(100, member_discount: 10), 0.001
  end
end
