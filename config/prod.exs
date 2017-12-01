use Mix.Config

# For production, we configure the host to read the PORT
# from the system environment. Therefore, you will need
# to set PORT=80 before running your server.
#
# You should also configure the url host to something
# meaningful, we use this information when generating URLs.
#
# Finally, we also include the path to a manifest
# containing the digested version of static files. This
# manifest is generated by the mix phoenix.digest task
# which you typically run after static files are built.
config :toss_bounty, TossBounty.Endpoint,
  http: [port: {:system, "PORT"}],
  url: [host: "api.toss-bounty.com", port: {:system, "PORT"}],
  server: true,
  root: ".",
  version: Application.spec(:toss_bounty, :vsn)

# Do not print debug messages in production
config :logger, level: :info

# ## SSL Support
#
# To get SSL working, you will need to add the `https` key
# to the previous section and set your `:url` port to 443:
#
#     config :toss_bounty, TossBounty.Endpoint,
#       ...
#       url: [host: "example.com", port: 443],
#       https: [port: 443,
#               keyfile: System.get_env("SOME_APP_SSL_KEY_PATH"),
#               certfile: System.get_env("SOME_APP_SSL_CERT_PATH")]
#
# Where those two env variables return an absolute path to
# the key and cert in disk or a relative path inside priv,
# for example "priv/ssl/server.key".
#
# We also recommend setting `force_ssl`, ensuring no data is
# ever sent via http, always redirecting to https:
#
#     config :toss_bounty, TossBounty.Endpoint,
#       force_ssl: [hsts: true]
#
# Check `Plug.SSL` for all available options in `force_ssl`.

# ## Using releases
#
# If you are doing OTP releases, you need to instruct Phoenix
# to start the server for all endpoints:
#
#     config :phoenix, :serve_endpoints, true
#
# Alternatively, you can configure exactly which server to
# start per endpoint:
#
#     config :toss_bounty, TossBounty.Endpoint, server: true
#

# Finally import the config/prod.secret.exs
# which should be versioned separately.
import_config "prod.secret.exs"

config :toss_bounty, repo_grabber: TossBounty.SellableRepos.TentacatReposGrabber
config :toss_bounty, issue_grabber: TossBounty.SellableIssues.TentacatIssuesGrabber
config :toss_bounty, github_strategy: TossBounty.GithubStrategy

config :reverse_proxy,
  upstreams: %{ "https://tossbounty.com" => [System.get_env("FRONT_END_URL")] }
