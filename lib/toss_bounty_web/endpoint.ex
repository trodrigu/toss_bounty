defmodule TossBountyWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :toss_bounty

  socket("/socket", TossBountyWeb.UserSocket)

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phoenix.digest
  # when deploying your static files in production.
  plug(
    Plug.Static,
    at: "/",
    from: :toss_bounty,
    gzip: false,
    only: ~w(css fonts images js favicon.ico robots.txt .well-known)
  )

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    socket("/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket)
    plug(Phoenix.LiveReloader)
    plug(Phoenix.CodeReloader)
  end

  plug(Plug.RequestId)
  plug(Plug.Logger)

  plug(
    Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Poison
  )

  plug(Plug.MethodOverride)
  plug(Plug.Head)

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  plug(
    Plug.Session,
    store: :cookie,
    key: "_toss_bounty_key",
    signing_salt: "AcqydKM3"
  )

  plug(
    Corsica,
    origins: [
      "http://localhost:8000",
      ~r{^https?://(.*\.?)tossbounty\.com$},
      ~r{https://api\.tossbounty\.com}
    ],
    allow_headers: [
      "accept",
      "authorization",
      "content-type",
      "origin",
      "cache-control",
      "access-control-allow-credentials"
    ],
    log: false,
    allow_credentials: true
  )

  plug(TossBountyWeb.Router)
end
