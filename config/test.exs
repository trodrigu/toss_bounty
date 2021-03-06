use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :toss_bounty, TossBountyWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :toss_bounty, TossBounty.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "toss_bounty_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :oauth2, Github,
  client_id: System.get_env("GITHUB_CLIENT_ID"),
  client_secret: System.get_env("GITHUB_CLIENT_SECRET"),
  redirect_uri: System.get_env("GITHUB_REDIRECT_URI")

config :toss_bounty, repo_grabber: TossBounty.Github.SellableRepos.MockReposGrabber
config :toss_bounty, issue_grabber: TossBounty.Github.SellableIssues.MockIssuesGrabber
config :toss_bounty, github_strategy: TossBountyWeb.MockGithubStrategy
config :toss_bounty, customer_creator: TossBounty.StripeProcessing.MockStripeCustomerCreator
config :toss_bounty, plan_creator: TossBounty.StripeProcessing.MockStripePlanCreator
config :toss_bounty, plan_deleter: TossBounty.StripeProcessing.MockStripePlanDeleter
config :toss_bounty, plan_updater: TossBounty.StripeProcessing.MockStripePlanUpdater

config :toss_bounty,
  subscription_creator: TossBounty.StripeProcessing.MockStripeSubscriptionCreator

config :toss_bounty,
  subscription_deleter: TossBounty.StripeProcessing.MockStripeSubscriptionDeleter

config :toss_bounty, front_end_url: "http://localhost:8000"

config :stripity_stripe, secret_key: System.get_env("STRIPE_SECRET_KEY")
config :stripity_stripe, platform_client_id: System.get_env("STRIPE_PLATFORM_CLIENT_ID")
config :toss_bounty, stripe_strategy: TossBountyWeb.MockStripeClientStrategy

config :toss_bounty, TossBountyWeb.Mailer, adapter: Bamboo.TestAdapter
config :bamboo, :refute_timeout, 10
