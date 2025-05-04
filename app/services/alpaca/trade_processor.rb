# frozen_string_literal: true

module Alpaca
  class TradeProcessor
    def initialize(trades)
      @trades = trades
    end

    def call
      @trades.each do |trade|
        process_trade(trade)
      end
    end

    private

    def process_trade(trade)
      return unless valid_trade?(trade)

      create_trade_record(trade)
    rescue StandardError => e
      Rails.logger.warn("Failed to process trade: #{e.message}")
    end

    def valid_trade?(trade)
      trade["T"] == "t" # Ensure this is really a trade
    end

    def create_trade_record(trade)
      # Alpaca's free market data offering includes live data only from the IEX exchange
      # https://docs.alpaca.markets/docs/historical-stock-data-1#data-sources
      # If Algo Trader Plus subscription is used, the exchange code can be extracted from trade["x"]
      exchange_name = Trade::EXCHANGE_NAME_IEX

      Trade.create!(
        stock_symbol: trade["S"],
        exchange_name: exchange_name,
        exchange_trade_id: trade["i"],
        price: trade["p"],
        quantity: trade["s"],
        timestamp: Time.zone.parse(trade["t"])
      )
      Rails.logger.info("Successfully processed trade for stock: #{trade['S']}")
    end
  end
end
