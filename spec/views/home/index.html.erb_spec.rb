# frozen_string_literal: true

require("rails_helper")

RSpec.describe("home/index") do
  before do
    assign(
      :trade_channels,
      [
        create(:trade_channel, stock_symbol: "AAPL"),
        create(:trade_channel, stock_symbol: "ORCL")
      ]
    )
  end

  context("when rendering the AAPL trade channel") do
    it("renders the AAPL trade channel element") do
      render
      expect(rendered).to(have_css('div[data-chart-symbol-value="AAPL"]'))
    end

    it("renders the correct chart URL for the AAPL trade channel") do
      render
      expect(rendered).to(have_css('div[data-chart-url-value="/trades/chart_data?stock_symbol=AAPL"]'))
    end
  end

  context("when rendering the ORCL trade channel") do
    it("renders the ORCL trade channel element") do
      render
      expect(rendered).to(have_css('div[data-chart-symbol-value="ORCL"]'))
    end

    it("renders the correct chart URL for the ORCL trade channel") do
      render
      expect(rendered).to(have_css('div[data-chart-url-value="/trades/chart_data?stock_symbol=ORCL"]'))
    end
  end

  it("includes a turbo stream subscription") do
    render
    expect(rendered).to(have_css('turbo-cable-stream-source[channel="Turbo::StreamsChannel"]'))
  end
end
