require "benchmark"
require "report_builder"

categories = (1..5_000).map { |i| { id: i, name: "Category #{i}" } }
rows = (1..5_000).map { |i| { category_id: 5_001 - i, currency: "TWD", amount: i * 1.5 } }

Benchmark.bm(10) do |x|
  x.report("report") { ReportBuilder.new(rows, categories).lines }
  x.report("formatter") { rows.each { |row| Formatter.new(row[:currency]).format(row[:amount]) } }
end
