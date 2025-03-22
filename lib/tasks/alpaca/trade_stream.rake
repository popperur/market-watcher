# frozen_string_literal: true

namespace(:alpaca) do
  # @example Run with Alpaca Live (IEX)
  #   bin/rails "alpaca:trade_stream"
  #
  # @example Run with Alpaca Sandbox (TEST)
  #   bin/rails "alpaca:trade_stream[sandbox]"
  desc("Start the WebSocket trade stream listener")
  task(:trade_stream, %i[sandbox] => :environment) do |_task, args|
    required_env_vars = %w[ALPACA_API_KEY ALPACA_API_SECRET]
    missing_vars = required_env_vars.select { |var| ENV[var].blank? }
    raise("Missing required environment variables: #{missing_vars.join(', ')}") if missing_vars.any?

    sandbox = args.fetch(:sandbox, nil) == "sandbox"
    # You might want to log into a separate file
    # Rails.logger = ActiveSupport::Logger.new(Rails.root.join("log/trade_stream.log"))
    Rails.logger = Logger.new($stdout)
    Rails.logger.info("Starting the trade stream listener, sandbox: #{sandbox}...")
    Alpaca::TradeStreamService.new(
      alpaca_api_key: ENV.fetch("ALPACA_API_KEY"),
      alpaca_api_secret: ENV.fetch("ALPACA_API_SECRET"),
      sandbox: sandbox
    ).call
  ensure
    Rails.logger = ActiveSupport::Logger.new(Rails.root.join("log/#{Rails.env}.log"))
  end
end
