require "csv"

module LedgerSync
  class BankCsv
    def initialize(dir)
      @dir = dir
    end

    def rows
      Dir[File.join(@dir, "*.csv")].sort.flat_map { |path| CSV.read(path, headers: true).map(&:to_h) }
    end
  end
end
