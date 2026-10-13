require_relative "customer"

module Sales
  OrderPlaced = Struct.new(:order_id, :recipient_name, :address, keyword_init: true)

  class Order
    attr_reader :id

    def initialize(id, customer)
      @id = id
      @customer = customer
    end

    def place
      OrderPlaced.new(order_id: @id, recipient_name: @customer.name, address: @customer.address)
    end
  end
end
