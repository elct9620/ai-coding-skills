require_relative "recipient"

module Shipping
  class Shipment
    attr_reader :order_id, :recipient

    def self.from_event(event)
      new(event.order_id, Recipient.new(name: event.recipient_name, address: event.address))
    end

    def self.from_order(order)
      customer = order.instance_variable_get(:@customer)
      new(order.id, Recipient.new(name: customer.name, address: customer.address, phone: customer.preferences[:phone]))
    end

    def initialize(order_id, recipient)
      @order_id = order_id
      @recipient = recipient
    end
  end
end
