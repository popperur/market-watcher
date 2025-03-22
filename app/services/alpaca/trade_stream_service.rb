# frozen_string_literal: true

require("websocket-client-simple")
require("json")

module Alpaca
  class TradeStreamService
    WEBSOCKET_URI_BASE = "wss://stream.data.alpaca.markets/v2"

    def initialize(alpaca_api_key:, alpaca_api_secret:, sandbox: false)
      @alpaca_api_key = alpaca_api_key
      @alpaca_api_secret = alpaca_api_secret
      @websocket_uri = "#{WEBSOCKET_URI_BASE}/#{sandbox ? 'test' : 'iex'}"
      @stock_symbols = sandbox ? [Trade::STOCK_SYMBOL_FAKEPACA] : Trade::STOCK_SYMBOLS
      @ws = nil
    end

    def call
      Rails.logger.info("Connecting to \"#{@websocket_uri}\"...")
      connect!
      loop { sleep(1) } # Keep connection alive
    end

    def authenticate!
      Rails.logger.info("Authenticating WebSocket connection...")
      @ws.send({
        action: "auth",
        key: @alpaca_api_key,
        secret: @alpaca_api_secret
      }.to_json)

      subscribe_to_trades!
    end

    def subscribe_to_trades!
      Rails.logger.info("Subscribing to trade updates for #{@stock_symbols.inspect}...")
      @ws.send({
        action: "subscribe",
        trades: @stock_symbols
      }.to_json)
    end

    def handle_message(msg)
      return if msg.data.blank?

      trades = JSON.parse(msg.data)
      Rails.logger.debug { "Incoming WS message: #{trades}" }
      Alpaca::TradeProcessor.new(trades).process
    end

    def handle_close(message, sleep_seconds: 5)
      Rails.logger.warn("WebSocket closed: #{message}")
      reconnect(sleep_seconds)
    end

    private

    def connect!
      @ws = WebSocket::Client::Simple.connect(@websocket_uri)
      service = self

      @ws.on(:open) { service.authenticate! }
      @ws.on(:message) { |msg| service.handle_message(msg) }
      @ws.on(:error) { |e| Rails.logger.error("WebSocket Error: #{e.message}") }
      @ws.on(:close) { |e| service.handle_close(e.message) }
    end

    def reconnect(sleep_seconds)
      Rails.logger.warn("Reconnecting to WebSocket...")
      sleep(sleep_seconds)
      connect!
    end
  end
end
