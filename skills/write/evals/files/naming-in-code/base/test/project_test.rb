require "minitest/autorun"
require_relative "../lib/project"

class ProjectTest < Minitest::Test
  def test_holds_segments_in_order
    project = Project.new([Segment.new(index: 1, text: "b"), Segment.new(index: 0, text: "a")])
    assert_equal %w[a b], project.segments.map(&:text)
  end
end
