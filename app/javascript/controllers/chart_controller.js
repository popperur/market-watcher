import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["chart", "symbolAndPrice"]
  static values = { url: String, symbol: String }

  connect() {
    this.chart = null
    this.chartData = { labels: [], values: [] }
    this.loadTrades()
  }

  loadTrades() {
    fetch(this.urlValue)
      .then(response => response.json())
      .then(data => {
        this.chartData = data
        this.renderChart(true)
      })
  }

  update({time, price}) {
    // Push new trade data into the array
    this.chartData.labels.push(time)
    this.chartData.values.push(price)
    this.renderChart()
  }

  renderChart(showAnimation = false) {
    const ctx = this.chartTarget.getContext("2d")

    if (this.chart) {
      this.chart.destroy()
    }

    this.chart = new Chart(ctx, {
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
        animation: showAnimation,
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
    if (this.chartData.values) {
      const currentPrice = this.chartData.values.slice(-1)[0]
      if (currentPrice) {
        this.symbolAndPriceTarget.textContent = `${this.symbolValue} - $${currentPrice.toFixed(2)}`
      }
    }
  }
}