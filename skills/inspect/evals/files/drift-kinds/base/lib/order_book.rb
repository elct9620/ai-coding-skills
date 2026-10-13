require_relative "order"

class OrderBook
  def initialize(orders)
    @orders = orders.sort_by(&:placed_on).reverse
  end

  def orders
    @orders
  end
end
