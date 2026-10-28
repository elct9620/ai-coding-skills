require_relative "formatter"

class ReportBuilder
  def initialize(rows, categories)
    @rows = rows
    @categories = categories
  end

  def lines
    @rows.map do |row|
      category = @categories.find { |c| c[:id] == row[:category_id] }
      formatter = Formatter.new(row[:currency])
      "#{category[:name]}\t#{formatter.format(row[:amount])}"
    end
  end
end
