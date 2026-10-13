require_relative "segment"

class Project
  attr_reader :segments

  def initialize(segments)
    @segments = segments.sort_by(&:index)
  end
end
