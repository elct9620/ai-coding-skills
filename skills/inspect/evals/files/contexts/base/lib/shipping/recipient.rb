module Shipping
  Recipient = Struct.new(:name, :address, :phone, keyword_init: true)
end
