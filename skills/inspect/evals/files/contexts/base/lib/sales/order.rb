require_relative "customer"

module Sales
  OrderPlaced = Struct.new(:order_id, :name, :address, :phone, keyword_init: true)

  class Order
    attr_reader :id

    def initialize(id, customer)
      @id = id
      @customer = customer
    end

    def place
      OrderPlaced.new(order_id: @id, name: @customer.name, address: @customer.address, phone: @customer.phone)
    end
  end
end
