use Mix.Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with brunch.io to recompile .js and .css sources.
config :toss_bounty, TossBountyWeb.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false

# Watch static and templates for browser reloading.
config :toss_bounty, TossBountyWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
      ~r{priv/gettext/.*(po)$},
      ~r{lib/toss_bounty/views/.*(ex)$},
      ~r{lib/toss_bounty/templates/.*(eex)$}
    ]
  ]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Configure your database
config :toss_bounty, TossBounty.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  database: "toss_bounty_dev",
  hostname: "localhost",
  pool_size: 10

config :oauth2, Github,
  client_id: System.get_env("GITHUB_CLIENT_ID"),
  client_secret: System.get_env("GITHUB_CLIENT_SECRET"),
  redirect_uri: System.get_env("GITHUB_REDIRECT_URI")

config :tentacat, :extra_headers, [{"Accept", "application/vnd.github.squirrel-girl-preview"}]

config :toss_bounty, repo_grabber: TossBounty.Github.SellableRepos.TentacatReposGrabber
config :toss_bounty, issue_grabber: TossBounty.Github.SellableIssues.TentacatIssuesGrabber
config :toss_bounty, github_strategy: TossBountyWeb.GithubStrategy
config :toss_bounty, customer_creator: TossBounty.StripeProcessing.StripeCustomerCreator
config :toss_bounty, plan_creator: TossBounty.StripeProcessing.StripePlanCreator
config :toss_bounty, plan_deleter: TossBounty.StripeProcessing.StripePlanDeleter
config :toss_bounty, plan_updater: TossBounty.StripeProcessing.StripePlanUpdater
config :toss_bounty, subscription_creator: TossBounty.StripeProcessing.StripeSubscriptionCreator
config :toss_bounty, subscription_deleter: TossBounty.StripeProcessing.StripeSubscriptionDeleter

config :toss_bounty, front_end_url: System.get_env("FRONT_END_URL")

config :stripity_stripe, api_key: System.get_env("STRIPE_SECRET_KEY")
config :stripity_stripe, connect_client_id: System.get_env("STRIPE_CONNECT_CLIENT_ID")

config :toss_bounty, stripe_strategy: TossBountyWeb.StripeClientStrategy
