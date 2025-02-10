# frozen_string_literal: true

require("rails_helper")

RSpec.describe("Home") do
  let(:user) { create(:user) }

  let!(:trades) do
    create_list(:trade, 3, stock_symbol: "AAPL")
  end
  let!(:last_trade) { create(:trade, stock_symbol: "AAPL", price: 102.50) }
  let!(:trade_channel) { create(:trade_channel, user: user, stock_symbol: "AAPL") }

  before do
    system_sign_in(user)
  end

  describe("chart display on page load") do
    it("displays the card for the stock chart") do
      expect(page).to(have_css('div.card[data-controller="chart"]'))
    end

    it("renders the chart") do
      canvas = find('canvas[data-chart-target="chart"]')
      # Check that width and height are non-zero, indicating the chart is rendered
      expect(canvas[:width].to_i.positive? && canvas[:height].to_i.positive?).to(be_truthy)
    end

    it("displays the last trade price") do
      expect(page).to(have_content("AAPL - $102.50"))
    end
  end
end
