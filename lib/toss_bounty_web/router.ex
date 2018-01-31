defmodule TossBountyWeb.Router do
  use TossBountyWeb.Web, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ~w(json json-api))
    plug(JaSerializer.Deserializer)
  end

  pipeline :bearer_auth do
    plug(Guardian.Plug.VerifyHeader, realm: "Bearer")
    plug(Guardian.Plug.LoadResource)
  end

  pipeline :current_user do
    plug(TossBounty.Accounts.CurrentUser)
  end

  pipeline :ensure_auth do
    plug(Guardian.Plug.EnsureAuthenticated)
  end

  scope "/", TossBountyWeb do
    # Use the default browser stack
    pipe_through(:browser)

    get("/", PageController, :index)
  end

  scope "/", TossBountyWeb do
    pipe_through([:browser, :current_user])

    get("/auth/:provider/callback", AuthController, :callback)
  end

  scope "/", TossBountyWeb do
    pipe_through([:api, :bearer_auth, :current_user])

    post("/token", TokenController, :create)
    post("/token/refresh", TokenController, :refresh)
    get("/github_oauth_url", GithubOauthUrlController, :show)
    get("/stripe_oauth_url", StripeOauthUrlController, :show)
  end

  scope "/", TossBountyWeb do
    pipe_through([:api, :bearer_auth, :current_user, :ensure_auth])

    resources("/users", UserController, only: [:create, :show, :update])
    resources("/github_repos", GithubRepoController, only: [:index])
    resources("/github_issues", GithubIssueController, only: [:index])
    resources("/campaigns", CampaignController, only: [:index, :show, :update, :create, :delete])
    resources("/rewards", RewardController, except: [:new, :edit])
    resources("/tokens", StripeTokenController, only: [:create])
    resources("/customers", CustomerController, only: [:create])
    resources("/plans", PlanController, only: [:create, :delete])
    resources("/subscriptions", SubscriptionController, only: [:create, :delete])
  end
end
