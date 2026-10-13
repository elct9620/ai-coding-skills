require "minitest/autorun"
require_relative "../lib/segment"

class SegmentTest < Minitest::Test
  def test_keeps_its_text
    assert_equal "hi", Segment.new(index: 0, text: "hi").text
  end
end
