import { Application } from "@hotwired/stimulus"
import ChartController from "../chart_controller"

describe("ChartController", () => {
  let application

  const getController = () => {
    const element = document.querySelector('[data-controller="chart"]')
    return application.getControllerForElementAndIdentifier(element, "chart")
  }

  beforeEach(() => {
    document.body.innerHTML = `
      <div data-controller="chart"
           data-chart-url-value="/trades/chart_data?stock_symbol=AAPL" 
           data-chart-symbol-value="AAPL">
        <div data-chart-target="symbolAndPrice"></div>
        <canvas data-chart-target="chart"></canvas>
      </div>
    `

    window.fetch = jest.fn().mockResolvedValue({
      json: async () => ({
        labels: ["22:09:11", "22:09:13"],
        values: [310.82, 310.18],
      }),
    })

    application = Application.start()
  })

  afterEach(() => {
    application.stop()
    jest.clearAllMocks()
    jest.restoreAllMocks()
  })

  describe("connect", () => {
    beforeEach(() => {
      jest.spyOn(ChartController.prototype, "loadTrades").mockImplementation(() => {})
      application.register("chart", ChartController)
    })

    it("sets this.chart to null", () => {
      expect(getController().chart).toBeNull()
    })

    it("sets this.chartData to a blank object", () => {
      expect(getController().chartData).toEqual({ labels: [], values: [] })
    })

    it("calls loadTrades()", () => {
      expect(ChartController.prototype.loadTrades).toHaveBeenCalled()
    })
  })

  describe("loadTrades", () => {
    beforeEach(() => {
      jest.spyOn(ChartController.prototype, "renderChart").mockImplementation(() => {})
      application.register("chart", ChartController)
    })

    it("calls fetch with the correct url", () => {
      expect(window.fetch).toHaveBeenCalledWith("/trades/chart_data?stock_symbol=AAPL")
    })

    it("stores the response in this.chartData", async () => {
      expect(getController().chartData).toEqual({
        labels: ["22:09:11", "22:09:13"],
        values: [310.82, 310.18],
      })
    })

    it("calls renderChart()", async () => {
      expect(ChartController.prototype.renderChart).toHaveBeenCalledWith(true)
    })
  })

  describe("update", () => {
    beforeEach(() => {
      jest.spyOn(ChartController.prototype, "loadTrades").mockImplementation(() => {})
      jest.spyOn(ChartController.prototype, "renderChart").mockImplementation(() => {})
      application.register("chart", ChartController)
      getController().update({ time: "10:15:22", price: 200 })
    })

    it("adds time to chartData.labels", () => {
      expect(getController().chartData.labels).toEqual(["10:15:22"])
    })

    it("adds price to chartData.values", () => {
      expect(getController().chartData.values).toEqual([200])
    })

    it("calls renderChart()", () => {
      expect(ChartController.prototype.renderChart).toHaveBeenCalled()
    })
  })

  describe("renderChart", () => {
    class MockChart {
      constructor() {
        this.destroy = jest.fn()
      }
    }

    beforeEach(() => {
      global.Chart = MockChart
      jest.spyOn(HTMLCanvasElement.prototype, "getContext").mockReturnValue({})
      application.register("chart", ChartController)
    })

    afterEach(() => {
      delete global.Chart
    })


    it("calls getContext on canvas", () => {
      expect(HTMLCanvasElement.prototype.getContext).toHaveBeenCalledWith("2d")
    })

    it("sets this.chart with a Chart instance", () => {
      expect(getController().chart).toBeInstanceOf(MockChart)
    })

    it("destroys previous chart instance when re-rendering", () => {
      const controller = getController()
      const oldChart = controller.chart
      controller.renderChart()
      expect(oldChart.destroy).toHaveBeenCalled()
    })
  })
})
