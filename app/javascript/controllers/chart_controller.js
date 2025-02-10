import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["chart", "symbolAndPrice"]
  static values = { url: String, symbol: String }

  connect() {
    this.loadTrades()
  }

  loadTrades() {
    fetch(this.urlValue)
      .then(response => response.json())
      .then(data => {
        this.chartData = data
        this.renderChart()
      })
  }

  update(trade) {
    // Push new trade data into the array
    // TODO: MARK
    // this.chartData.labels.push(trade.time)
    // this.chartData.values.push(trade.price)
    // this.renderChart()
  }

  renderChart() {
    const ctx = this.chartTarget.getContext('2d')
    new Chart(ctx, {
      type: "line",
      data: {
        labels: this.chartData.labels,
        datasets: [
          {
            label: "Stock Price",
            data: this.chartData.values,
            borderColor: "blue",
            borderWidth: 1,
            backgroundColor: "rgba(0, 0, 255, 0.2)",
            fill: true
          },
        ],
      },
      options: {
        plugins: {
          legend: {
            display: false
          },
          tooltip: {
            callbacks: {
              label: (context) => {
                return `Stock Price: $${context.raw.toFixed(2)}`
              },
            },
          }
        },
        scales: {
          x: {
            ticks: {
              font: {
                family: "'Inter var', sans-serif",
              },
              callback: (index) => {
                const tokens = this.chartData.labels[index].split(":")
                return `${tokens[1]}:${tokens[2]}`
              }

            },
          },
          y: {
            ticks: {
              font: {
                family: "'Inter var', sans-serif",
              },
            },
          },
        },
      },
    })
    const currentPrice = this.chartData.values.slice(-1)[0]
    this.symbolAndPriceTarget.textContent = `${this.symbolValue} - $${currentPrice.toFixed(2)}`
  }
}