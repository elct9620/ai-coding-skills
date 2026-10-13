module LedgerSync
  class Ledger
    def initialize(path)
      @path = path
    end

    def append(entry)
      File.open(@path, "a") { |file| file.puts(entry) }
    end

    def balances
      Hash.new(0).tap do |totals|
        File.foreach(@path) do |line|
          account, amount = line.split
          totals[account] += amount.to_f if amount
        end
      end
    end
  end
end
