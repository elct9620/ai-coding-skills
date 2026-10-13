module Sales
  Customer = Struct.new(:name, :email, :address, :preferences, keyword_init: true)
end
