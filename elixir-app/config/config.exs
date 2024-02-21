import Config

config :logger,
  backends: [:console],
  level: :info

config :logger, :console,
  metadata: :all,
  device: :standard_error
