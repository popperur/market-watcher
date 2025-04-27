# frozen_string_literal: true

class TradesController < ApplicationController
  before_action(:authenticate_user!)

  def chart_data
    trades = Trade.order(timestamp: :desc)
    trades = trades.where(stock_symbol: params[:stock_symbol]) if params[:stock_symbol].present?
    formatted_trades = trades.limit(50).pluck(:timestamp, :price).reverse
    labels, values = formatted_trades.map { |timestamp, price| [timestamp.strftime("%H:%M:%S"), price.to_f] }.transpose
    render(
      json: {
        labels: labels || [],
        values: values || []
      }
    )
  end
end
