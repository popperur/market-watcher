# frozen_string_literal: true

FactoryBot.define do
  factory(:trade) do
    price { rand(1.0..500.0) }
    quantity { rand(100..500) }
    stock_symbol { Trade::STOCK_SYMBOLS.sample }
    exchange_name { Trade::EXCHANGE_NAMES.sample }
    exchange_trade_id { SecureRandom.uuid }
    timestamp { Time.zone.now }
  end
end
