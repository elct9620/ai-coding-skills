require "minitest/autorun"
require_relative "../lib/sales/order"
require_relative "../lib/shipping/shipment"

class ShipmentTest < Minitest::Test
  def setup
    @order = Sales::Order.new(7, Sales::Customer.new(name: "Ann", email: "ann@example.com", address: "1 Main St", phone: "555"))
  end

  def test_ships_to_the_address_in_the_event
    assert_equal "1 Main St", Shipping::Shipment.from_event(@order.place).recipient.address
  end

  def test_builds_a_shipment_straight_from_an_order
    assert_equal "555", Shipping::Shipment.from_order(@order).recipient.phone
  end
end
