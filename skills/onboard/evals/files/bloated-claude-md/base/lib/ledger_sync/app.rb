require_relative "bank_csv"
require_relative "ledger"
require_relative "matcher"

module LedgerSync
  class App
    def self.build(data_dir: "data", ledger_path: "ledger.beancount")
      new(BankCsv.new(data_dir), Ledger.new(ledger_path), Matcher.new)
    end

    def initialize(source, ledger, matcher)
      @source = source
      @ledger = ledger
      @matcher = matcher
    end

    def import
      @source.rows.each { |row| @ledger.append(@matcher.entry_for(row)) }
    end

    def balance
      @ledger.balances.each { |account, amount| puts "#{account} #{amount}" }
    end
  end
end
