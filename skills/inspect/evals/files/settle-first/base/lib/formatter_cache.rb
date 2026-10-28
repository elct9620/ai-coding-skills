require_relative "formatter"

# Keeps one Formatter per currency.
class FormatterCache
  def initialize
    @formatters = {}
  end

  def fetch(currency)
    @formatters[currency] ||= Formatter.new(currency)
  end
end
