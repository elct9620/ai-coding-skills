require_relative "money_format"

class Invoice
  def initialize(lines)
    @lines = lines
  end

  def total_cents
    @lines.sum { |line| line[:cents] }
  end

  def summary
    "Total due: #{MoneyFormat.dollars(total_cents)}"
  end
end
