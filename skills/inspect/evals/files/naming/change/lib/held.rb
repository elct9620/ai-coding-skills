require "json"
require_relative "segment"

class Held
  attr_reader :path, :segments

  def self.inherited(subclass)
    registry << subclass
  end

  def self.registry
    @registry ||= []
  end

  def initialize(path, segments)
    @path = path
    @segments = segments
    @worker = nil
  end

  def get_title
    File.basename(@path, ".json")
  end

  def running
    !@worker.nil? && @worker.alive?
  end

  def translated(language, lines)
    File.write("#{@path}.#{language}.json", JSON.generate(lines))
  end

  def to_s
    "#{get_title} (#{@segments.size} segments)"
  end
end
