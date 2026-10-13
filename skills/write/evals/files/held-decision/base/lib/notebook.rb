require_relative "note"

class Notebook
  attr_reader :notes, :pinned

  def initialize
    @notes = []
    @pinned = []
  end

  def add(note)
    @notes << note
    note
  end

  def pin(note)
    @pinned.unshift(note)
  end
end
