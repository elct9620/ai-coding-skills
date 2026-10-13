module MoneyFormat
  def self.dollars(cents)
    "$#{cents / 100}.#{cents % 100}"
  end
end
