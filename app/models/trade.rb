# frozen_string_literal: true

class Trade < ApplicationRecord
  STOCK_SYMBOL_AAPL = "AAPL"
  STOCK_SYMBOL_FAKEPACA = "FAKEPACA" # stock symbol used for sandbox
  STOCK_SYMBOLS = (%w[INST ORCL TSLA] + [STOCK_SYMBOL_AAPL, STOCK_SYMBOL_FAKEPACA]).sort.freeze

  # Alpaca's free market data offering includes live data only from the IEX exchange
  # https://docs.alpaca.markets/docs/historical-stock-data-1#data-sources
  EXCHANGE_NAME_IEX = "IEX"
  EXCHANGE_NAMES = [EXCHANGE_NAME_IEX].freeze

  validates(:stock_symbol, presence: true, inclusion: { in: STOCK_SYMBOLS })
  validates(:exchange_name, presence: true, inclusion: { in: EXCHANGE_NAMES })
  validates(:exchange_trade_id, presence: true)
  validates(:price, presence: true, numericality: { greater_than: 0 })
  validates(:quantity, presence: true, numericality: { only_integer: true, greater_than: 0 })
  validates(:timestamp, presence: true)

  after_create_commit(:broadcast_trade_to_channel)

  private

  def broadcast_trade_to_channel
    broadcast_replace_to(
      "trade_channel_#{stock_symbol}",
      target: "stimulus_target_#{stock_symbol}"
    )
  end
end
