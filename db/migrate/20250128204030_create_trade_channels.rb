# frozen_string_literal: true

class CreateTradeChannels < ActiveRecord::Migration[8.0]
  def change
    create_table(:trade_channels) do |t|
      t.string(:stock_symbol, null: false)
      t.references(:user, null: false)

      t.timestamps
    end
  end
end
