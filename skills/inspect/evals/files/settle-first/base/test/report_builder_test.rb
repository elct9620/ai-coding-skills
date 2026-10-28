require "minitest/autorun"
require "report_builder"

class ReportBuilderTest < Minitest::Test
  def test_lines_pair_category_and_amount
    builder = ReportBuilder.new([{ category_id: 2, currency: "TWD", amount: 3 }],
                                [{ id: 1, name: "Food" }, { id: 2, name: "Books" }])
    assert_equal ["Books\tTWD 3.00"], builder.lines
  end
end
