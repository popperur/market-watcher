# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for(:users)

  get("up" => "rails/health#show", as: :rails_health_check)
  get("/trades/chart_data", to: "trades#chart_data")

  root("home#index")
end
