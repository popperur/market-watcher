import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static outlets = [ "chart" ]
  static values = {
    symbol: String,
    price: Number,
    time: String,
  }

  connect() {
    this.updateChart()
  }

  getChartController() {
    for (const chartController of this.chartOutlets) {
      if (chartController.symbolValue === this.symbolValue) {
        return chartController
      }
    }
    return null;
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
