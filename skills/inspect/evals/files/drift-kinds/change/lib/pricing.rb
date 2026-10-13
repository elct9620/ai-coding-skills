class Pricing
  def initialize(tax_rate:)
    @tax_rate = tax_rate
  end

  def total(subtotal, member_discount: 0)
    subtotal * (1 + @tax_rate) - member_discount
  end
end
