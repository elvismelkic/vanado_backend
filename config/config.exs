# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :vanado_backend,
  ecto_repos: [VanadoBackend.Repo]

# Configures the endpoint
config :vanado_backend, VanadoBackendWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "TrF7EensLsnHBRMCU81L5V7zVbWFBII2cfYWn1NUPlUTtXz0/Xtaxk+4woOIEXPe",
  render_errors: [view: VanadoBackendWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: VanadoBackend.PubSub,
  live_view: [signing_salt: "9cxg3mhL"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
