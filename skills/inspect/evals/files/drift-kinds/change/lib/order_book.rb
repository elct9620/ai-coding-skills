require "csv"
require_relative "order"

class OrderBook
  PAGE_SIZE = 20

  def initialize(orders)
    @orders = orders.sort_by(&:placed_on).reverse
  end

  def orders
    @orders
  end

  def page_after(after_id = nil)
    start = after_id ? @orders.index { |order| order.id == after_id } + 1 : 0
    @orders[start, PAGE_SIZE] || []
  end

  def to_csv(pricing)
    CSV.generate do |csv|
      csv << %w[id placed_on status total]
      @orders.reject { |order| order.status == "cancelled" }.each do |order|
        csv << [order.id, order.placed_on, order.status, pricing.total(order.subtotal)]
      end
    end
  end
end
