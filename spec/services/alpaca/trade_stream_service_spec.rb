# frozen_string_literal: true

require("rails_helper")

RSpec.describe(Alpaca::TradeStreamService) do
  let(:websocket_uri) { "#{described_class::WEBSOCKET_URI_BASE}/iex" }
  let(:service) do
    described_class.new(alpaca_api_key: "fake_api_key", alpaca_api_secret: "fake_api_secret", sandbox: false)
  end
  let(:websocket_double) { double("WebSocket::Client::Simple") }

  before do
    allow(WebSocket::Client::Simple).to(receive(:connect).and_return(websocket_double))
    allow(websocket_double).to(receive(:send))
    allow(websocket_double).to(receive(:on))
  end

  describe("#call") do
    before do
      allow(service).to(receive(:loop).and_yield)
    end

    it("logs the connection") do
      allow(Rails.logger).to(receive(:info))
      service.call
      expect(Rails.logger).to(have_received(:info).with("Connecting to \"#{websocket_uri}\"..."))
    end

    describe("connection") do
      it("connects a web socket client and sets up event handlers") do
        allow(WebSocket::Client::Simple).to(receive(:connect).with(websocket_uri).and_return(websocket_double))
        service.call
        expect(WebSocket::Client::Simple).to(have_received(:connect).with(websocket_uri))
      end

      describe("message handlers") do
        it("sets a handler for an open event") do
          service.call
          expect(websocket_double).to(have_received(:on).with(:open))
        end

        it("sets a handler for a close event") do
          service.call
          expect(websocket_double).to(have_received(:on).with(:close))
        end

        it("sets a handler for an error event") do
          service.call
          expect(websocket_double).to(have_received(:on).with(:error))
        end

        it("sets a handler for a message event") do
          service.call
          expect(websocket_double).to(have_received(:on).with(:message))
        end
      end
    end
  end

  describe("#authenticate!") do
    before do
      service.instance_variable_set(:@ws, websocket_double)
    end

    it("sends authentication data to the web socket") do
      service.authenticate!
      expect(websocket_double).to(have_received(:send).with({
        action: "auth",
        key: "fake_api_key",
        secret: "fake_api_secret"
      }.to_json))
    end

    it("subscribes to trades after authentication") do
      allow(service).to(receive(:subscribe_to_trades!))
      service.authenticate!
      expect(service).to(have_received(:subscribe_to_trades!))
    end
  end

  describe("#subscribe_to_trades!") do
    before do
      service.instance_variable_set(:@ws, websocket_double)
    end

    it("sends a subscription message to the web socket") do
      service.subscribe_to_trades!
      expect(websocket_double).to(have_received(:send).with({
        action: "subscribe",
        trades: Trade::STOCK_SYMBOLS
      }.to_json))
    end

    it("logs the subscription info") do
      allow(Rails.logger).to(receive(:info))
      service.subscribe_to_trades!
      expect(Rails.logger)
        .to(have_received(:info)
        .with("Subscribing to trade updates for #{Trade::STOCK_SYMBOLS.inspect}..."))
    end
  end

  describe("#handle_message") do
    let(:message_data) { { "T" => "t", "S" => "AAPL" }.to_json }
    let(:message_double) { double("Message", data: message_data) }

    before do
      allow(Alpaca::TradeProcessor).to(receive(:new).and_return(instance_double(Alpaca::TradeProcessor, process: true)))
    end

    it("parses the message and processes the trades") do
      trade_processor = instance_double(Alpaca::TradeProcessor)
      allow(Alpaca::TradeProcessor).to(receive(:new).with(JSON.parse(message_data)).and_return(trade_processor))
      allow(trade_processor).to(receive(:process))
      service.handle_message(message_double)
      expect(trade_processor).to(have_received(:process))
    end

    it("does nothing if the message data is blank") do
      blank_message = double("Message", data: nil)
      service.handle_message(blank_message)
      expect(Alpaca::TradeProcessor).not_to(have_received(:new))
    end
  end

  describe("#handle_close") do
    let(:close_message) { "Connection closed" }

    it("reconnects") do
      allow(service).to(receive(:connect!))
      service.handle_close(close_message, sleep_seconds: 0)
      expect(service).to(have_received(:connect!))
    end

    it("logs a warning") do
      allow(Rails.logger).to(receive(:warn))
      service.handle_close(close_message, sleep_seconds: 0)
      expect(Rails.logger).to(have_received(:warn).with("WebSocket closed: #{close_message}"))
    end
  end
end
