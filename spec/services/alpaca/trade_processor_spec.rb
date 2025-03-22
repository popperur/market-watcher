# frozen_string_literal: true

require("rails_helper")

RSpec.describe(Alpaca::TradeProcessor) do
  subject(:trade_processor) { described_class.new(trades) }

  let(:valid_trade) do
    {
      "T" => "t", # Event type
      "S" => "AAPL", # Stock symbol
      "i" => "12345", # Exchange trade ID
      "p" => 150.50, # Price
      "s" => 10, # Quantity
      "t" => "2023-11-07T10:00:00Z" # Timestamp
    }
  end

  let(:invalid_trade) do
    # set a type that is not a trade type
    valid_trade.merge("T" => "q")
  end

  describe("#process") do
    context("when processing a valid trade") do
      let(:trades) { [valid_trade] }

      before do
        allow(Trade).to(receive(:create!))
      end

      it("creates a trade record") do
        trade_processor.process
        expect(Trade).to(have_received(:create!).with(
                           stock_symbol: "AAPL",
                           exchange_name: Trade::EXCHANGE_NAME_IEX,
                           exchange_trade_id: "12345",
                           price: 150.50,
                           quantity: 10,
                           timestamp: Time.zone.parse("2023-11-07T10:00:00Z")
                         ))
      end

      it("logs a success message") do
        allow(Rails.logger).to(receive(:info))
        trade_processor.process
        expect(Rails.logger).to(have_received(:info).with("Successfully processed trade for stock: AAPL"))
      end
    end

    context("when processing an invalid trade") do
      let(:trades) { [invalid_trade] }

      before do
        allow(Trade).to(receive(:create!))
      end

      it("does not create a trade record") do
        trade_processor.process
        expect(Trade).not_to(have_received(:create!))
      end
    end

    context("when an error occurs during trade processing") do
      let(:trades) { [valid_trade] }

      before do
        allow(Trade).to(receive(:create!).and_raise(StandardError, "Test error"))
      end

      it("logs a warning message") do
        allow(Rails.logger).to(receive(:warn))
        trade_processor.process
        expect(Rails.logger).to(have_received(:warn).with("Failed to process trade: Test error"))
      end
    end
  end
end
