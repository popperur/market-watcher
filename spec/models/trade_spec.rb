# frozen_string_literal: true

require("rails_helper")

RSpec.describe(Trade) do
  describe("validations") do
    describe("stock_symbol") do
      it { is_expected.to(validate_presence_of(:stock_symbol)) }
      it { is_expected.to(validate_inclusion_of(:stock_symbol).in_array(Trade::STOCK_SYMBOLS)) }
    end

    describe("exchange_name") do
      it { is_expected.to(validate_presence_of(:exchange_name)) }
      it { is_expected.to(validate_inclusion_of(:exchange_name).in_array(Trade::EXCHANGE_NAMES)) }
    end

    describe("exchange_trade_id") do
      it { is_expected.to(validate_presence_of(:exchange_trade_id)) }
    end

    describe("price") do
      it { is_expected.to(validate_presence_of(:price)) }
      it { is_expected.to(validate_numericality_of(:price).is_greater_than(0)) }
    end

    describe("quantity") do
      it { is_expected.to(validate_presence_of(:quantity)) }
      it { is_expected.to(validate_numericality_of(:quantity).only_integer.is_greater_than(0)) }
    end

    describe("timestamp") do
      it { is_expected.to(validate_presence_of(:timestamp)) }
    end
  end

  describe("factories") do
    it("has a valid factory") do
      expect(build(:trade)).to(be_valid)
    end
  end

  describe("#formatted_timestamp") do
    let(:trade) { build(:trade, timestamp: Time.zone.parse("2023-12-10 08:23:15")) }

    it("returns a formatted timestamp") do
      expect(trade.formatted_timestamp).to(eq("08:23:15"))
    end
  end

  describe("callbacks") do
    it("broadcasts to trades after creation") do
      trade = build(:trade, stock_symbol: "AAPL")
      allow(trade).to(receive(:broadcast_replace_to))
      trade.save!
      expect(trade).to(
        have_received(:broadcast_replace_to).with(
          "trade_channel_AAPL",
          target: "stimulus_target_AAPL"
        )
      )
    end
  end
end
