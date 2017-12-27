defmodule TossBountyWeb.Router do
  use TossBountyWeb.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ~w(json json-api)
    plug JaSerializer.Deserializer
  end

  pipeline :bearer_auth do
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource
  end

  pipeline :current_user do
    plug TossBounty.Accounts.CurrentUser
  end

  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated
  end

  scope "/", TossBountyWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/", TossBountyWeb do
    pipe_through [:browser, :current_user]

    get "/auth/:provider/callback", AuthController, :callback
  end

  scope "/", TossBountyWeb do
    pipe_through [:api, :bearer_auth, :current_user]

    post "/token", TokenController, :create
    post "/token/refresh", TokenController, :refresh
    get "/github_oauth_url", GitHubOauthUrlController, :show
    get "/stripe_oauth_url", StripeOauthUrlController, :show
  end

  scope "/", TossBountyWeb do
    pipe_through [:api, :bearer_auth, :current_user, :ensure_auth]

    resources "/users", UserController, only: [:create, :show, :update]
    resources "/github_repos", GitHubRepoController, only: [:index]
    resources "/github_issues", GitHubIssueController, only: [:index]
    resources "/campaigns", CampaignController, only: [:index, :show, :update, :create, :delete]
  end
end
