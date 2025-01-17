# frozen_string_literal: true

class DeviseCreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table(:users) do |t|
      t.string(:name, null: false)

      ## Database authenticatable
      t.string(:email, null: false, index: { unique: true })
      t.string(:encrypted_password, null: false)

      ## Recoverable
      t.string(:reset_password_token, index: { unique: true })
      t.datetime(:reset_password_sent_at)

      ## Rememberable
      t.datetime(:remember_created_at)

      t.timestamps(null: false)
    end
  end
end
