# frozen_string_literal: true

require("rails_helper")

RSpec.describe(TradeChannel) do
  describe("associations") do
    it { is_expected.to(belong_to(:user)) }
  end

  describe("validations") do
    describe("stock_symbol") do
      it { is_expected.to(validate_presence_of(:stock_symbol)) }
      it { is_expected.to(validate_inclusion_of(:stock_symbol).in_array(Trade::STOCK_SYMBOLS)) }
    end
  end

  describe("factories") do
    it("has a valid factory") do
      expect(build(:trade_channel)).to(be_valid)
    end
  end
end
