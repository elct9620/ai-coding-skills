require "minitest/autorun"
require_relative "../lib/notebook"

class NotebookTest < Minitest::Test
  def setup
    @book = Notebook.new
    @first = @book.add(Note.new(title: "a", body: "", tags: ["ops"]))
    @second = @book.add(Note.new(title: "b", body: "", tags: ["dev"]))
  end

  def test_pinned_list_shows_the_newest_pin_first
    @book.pin(@first)
    @book.pin(@second)
    assert_equal [@second, @first], @book.pinned
  end
end
