require "minitest/autorun"
require_relative "../lib/sales/order"
require_relative "../lib/shipping/shipment"

class ShipmentTest < Minitest::Test
  def setup
    @order = Sales::Order.new(7, Sales::Customer.new(name: "Ann", address: "1 Main St", preferences: { phone: "555" }))
  end

  def test_ships_to_the_address_in_the_event
    assert_equal "1 Main St", Shipping::Shipment.from_event(@order.place).recipient.address
  end

  def test_carries_the_phone_for_the_courier
    assert_equal "555", Shipping::Shipment.from_order(@order).recipient.phone
  end
end
