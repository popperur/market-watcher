import { Application } from "@hotwired/stimulus"
import TradeUpdaterController from "../trade_updater_controller"

describe("TradeUpdaterController", () => {
  let application
  let mockUpdate

  beforeEach(() => {
    document.body.innerHTML = `
      <div data-controller="chart" data-chart-symbol-value="AAPL"></div>

      <div data-controller="trade-updater"
           data-trade-updater-symbol-value="AAPL"
           data-trade-updater-price-value="200"
           data-trade-updater-time-value="10:15:22">
      </div>
    `
    application = Application.start()
    mockUpdate = jest.fn()

    const mockChartController = {
      update: mockUpdate,
    }

    // Set mock before registering controller to ensure connect() sees it
    application.getControllerForElementAndIdentifier = jest.fn(
      () => mockChartController,
    )
  })

  afterEach(() => {
    application.stop()
    jest.restoreAllMocks()
  })

  it("calls update on the matching chart controller with correct data", () => {
    // trigger connect()
    application.register("trade-updater", TradeUpdaterController)

    expect(mockUpdate).toHaveBeenCalledWith({
      price: 200,
      time: "10:15:22",
    })
  })

  it("logs an error if the chart element is missing", () => {
    const consoleSpy = jest.spyOn(console, "error").mockImplementation(() => {})

    // remove the chart element before checking
    const chartElement = document.querySelector("[data-controller='chart']")
    chartElement.remove()

    // trigger connect()
    application.register("trade-updater", TradeUpdaterController)

    expect(consoleSpy).toHaveBeenCalledWith(
      "No matching chart controller for symbol:",
      "AAPL",
    )
  })
})
