module Sales
  Customer = Struct.new(:name, :email, :address, :phone, keyword_init: true)
end
