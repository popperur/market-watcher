# frozen_string_literal: true

require("rails_helper")

RSpec.describe("home/_trade_channel") do
  let(:trade_channel) { create(:trade_channel, stock_symbol: "AAPL") }

  before do
    render(partial: "home/trade_channel", locals: { trade_channel: trade_channel })
  end

  it("includes a turbo stream subscription") do
    expect(rendered).to(have_css('turbo-cable-stream-source[channel="Turbo::StreamsChannel"]'))
  end

  it("renders the stimulus target for the trade updates") do
    expect(rendered).to(have_css('div[id="stimulus_target_AAPL"]'))
  end

  describe("chart controller") do
    it("renders the trade channel element") do
      expect(rendered).to(have_css('div[data-chart-symbol-value="AAPL"]'))
    end

    it("renders the correct chart URL for the trade channel") do
      expect(rendered).to(have_css('div[data-chart-url-value="/trades/chart_data?stock_symbol=AAPL"]'))
    end

    it("renders the canvas for the chart") do
      expect(rendered).to(have_css('canvas[data-chart-target="chart"]'))
    end
  end
end
