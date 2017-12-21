# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

config :phoenix, :format_encoders, "json-api": Poison

config :mime, :types, %{
  "application/vnd.api+json" => ["json-api"]
}

# General application configuration
config :toss_bounty,
  ecto_repos: [TossBounty.Repo]

# Configures the endpoint
config :toss_bounty, TossBountyWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "MAjVtcm9+3sgx0N/rAUPlgtkkZ1fC8X5lWUaCrXFl9GxDz0HOlr3yKhoZ+DWggzz",
  render_errors: [view: TossBountyWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: TossBounty.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

config :ja_resource,
  repo: TossBounty.Repo

config :guardian, Guardian,
  issuer: "TossBounty",
  ttl: { 30, :days },
  secret_key: System.get_env("GUARDIAN_SECRET_KEY"),
  serializer: TossBounty.GuardianSerializer

config :tentacat, :extra_headers, [{"Accept", "application/vnd.github.squirrel-girl-preview"}]
