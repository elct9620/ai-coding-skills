require "minitest/autorun"
require "tmpdir"
require_relative "../lib/held"

class HeldTest < Minitest::Test
  def test_title_comes_from_the_file_name
    assert_equal "intro", Held.new("/tmp/intro.json", []).get_title
  end

  def test_is_idle_until_a_worker_starts
    refute Held.new("/tmp/intro.json", []).running
  end

  def test_writes_translations_beside_the_project
    Dir.mktmpdir do |dir|
      Held.new("#{dir}/intro", []).translated("ja", ["こんにちは"])
      assert File.exist?("#{dir}/intro.ja.json")
    end
  end
end
