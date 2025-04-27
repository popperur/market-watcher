# frozen_string_literal: true

require("rails_helper")

RSpec.describe("home/index") do
  let(:trade_channels) { build_list(:trade_channel, 3) }

  before do
    assign(:trade_channels, trade_channels)
    render
  end

  it("renders the trade_channels collection inside the wrapper div") do
    expect(rendered).to(have_css("div.flex.flex-row.w-full.justify-center.gap-8"))
  end

  it("renders the trade channels") do
    expect(rendered).to(have_css("div[data-chart-symbol-value]", count: 3))
  end
end
