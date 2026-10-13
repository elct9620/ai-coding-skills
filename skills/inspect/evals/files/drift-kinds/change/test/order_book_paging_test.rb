require "minitest/autorun"
require "date"
require_relative "../lib/order_book"
require_relative "../lib/pricing"

class OrderBookPagingTest < Minitest::Test
  def setup
    @orders = (1..45).map { |i| Order.new(id: i, placed_on: Date.new(2026, 1, 1) + i, status: i == 3 ? "cancelled" : "paid", subtotal: 10) }
    @book = OrderBook.new(@orders)
  end

  def test_first_page_holds_twenty_orders
    assert_equal 20, @book.page_after.size
  end

  def test_next_page_starts_after_the_given_order
    assert_equal 25, @book.page_after(26).first.id
  end

  def test_csv_has_a_header_and_a_row_per_order
    lines = @book.to_csv(Pricing.new(tax_rate: 0)).lines
    assert_equal "id,placed_on,status,total\n", lines.first
  end
end
