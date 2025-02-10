# frozen_string_literal: true

FactoryBot.define do
  factory(:trade_channel) do
    user
    stock_symbol { Trade::STOCK_SYMBOLS.sample }
  end
end
