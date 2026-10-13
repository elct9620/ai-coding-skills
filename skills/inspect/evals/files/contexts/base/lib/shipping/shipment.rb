require_relative "recipient"

module Shipping
  class Shipment
    attr_reader :order_id, :recipient

    def self.from_event(event)
      new(event.order_id, Recipient.new(name: event.name, address: event.address, phone: event.phone))
    end

    def self.from_order(order)
      customer = order.instance_variable_get(:@customer)
      new(order.id, Recipient.new(name: customer.name, address: customer.address, phone: customer.phone))
    end

    def initialize(order_id, recipient)
      @order_id = order_id
      @recipient = recipient
    end
  end
end
