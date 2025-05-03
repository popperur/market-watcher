import { Application } from "@hotwired/stimulus"
import TradeUpdaterController from "../trade_updater_controller"

describe("TradeUpdaterController", () => {
  let application

  beforeEach(() => {
    document.body.innerHTML = `
      <div data-controller="chart" data-chart-symbol-value="AAPL"></div>
      <div data-controller="trade-updater"
           data-trade-updater-chart-outlet=".chart"
           data-trade-updater-symbol-value="AAPL"
           data-trade-updater-price-value="200"
           data-trade-updater-time-value="10:15:22">
      </div>
    `
    application = Application.start()
  })

  afterEach(() => {
    application.stop()
    jest.restoreAllMocks()
  })

  it("calls update on the matching chart controller with correct data", () => {
    const mockUpdate = jest.fn()
    const mockChartController = {
      update: mockUpdate,
    }

    jest
      .spyOn(TradeUpdaterController.prototype, "getChartController")
      .mockImplementation(() => mockChartController);

    // trigger connect()
    application.register("trade-updater", TradeUpdaterController)

    expect(mockUpdate).toHaveBeenCalledWith({
      price: 200,
      time: "10:15:22",
    })
  })

  it("logs an error if the chart element is missing", () => {
    const consoleSpy = jest.spyOn(console, "error").mockImplementation(() => {})
    jest.spyOn(TradeUpdaterController.prototype, "getChartController").mockImplementation(() => null);

    // trigger connect()
    application.register("trade-updater", TradeUpdaterController)

    expect(consoleSpy).toHaveBeenCalledWith(
      "No matching chart controller for symbol:",
      "AAPL",
    )
  })
})
