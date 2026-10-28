class Formatter
  def initialize(currency)
    @currency = currency
  end

  def format(amount)
    "#{@currency} #{'%.2f' % amount}"
  end
end
