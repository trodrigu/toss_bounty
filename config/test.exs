use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :toss_bounty, TossBounty.Endpoint,
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

config :oauth2, GitHub,
  client_id: System.get_env("GITHUB_CLIENT_ID"),
  client_secret: System.get_env("GITHUB_CLIENT_SECRET"),
  redirect_uri: System.get_env("GITHUB_REDIRECT_URI")

config :toss_bounty, repo_grabber: TossBounty.SellableRepos.MockReposGrabber
config :toss_bounty, issue_grabber: TossBounty.SellableIssues.MockIssuesGrabber
