require_relative "money_format"

class Receipt
  def initialize(paid_cents)
    @paid_cents = paid_cents
  end

  def summary
    "Paid: #{MoneyFormat.dollars(@paid_cents)}"
  end
end
