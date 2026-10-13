require "minitest/autorun"
require "date"
require_relative "../lib/order_book"

class OrderBookTest < Minitest::Test
  def test_lists_newest_orders_first
    old = Order.new(id: 1, placed_on: Date.new(2026, 1, 1), status: "paid", subtotal: 10)
    new = Order.new(id: 2, placed_on: Date.new(2026, 2, 1), status: "paid", subtotal: 10)
    assert_equal [2, 1], OrderBook.new([old, new]).orders.map(&:id)
  end
end
