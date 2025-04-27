import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    symbol: String,
    price: Number,
    time: String,
  }

  connect() {
    this.updateChart()
  }

  getChartController() {
    const controllerElement = document.querySelector(
      `[data-controller='chart'][data-chart-symbol-value='${this.symbolValue}']`,
    )
    if (!controllerElement) {
      return null
    }

    return this.application.getControllerForElementAndIdentifier(
      controllerElement,
      "chart",
    )
  }

  updateChart() {
    const chartController = this.getChartController()
    if (chartController) {
      chartController.update({
        time: this.timeValue,
        price: this.priceValue,
      })
    } else {
      console.error(
        "No matching chart controller for symbol:",
        this.symbolValue,
      )
    }
  }
}
