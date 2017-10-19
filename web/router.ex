defmodule TossBounty.Router do
  use TossBounty.Web, :router

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
    plug TossBounty.CurrentUser
  end

  scope "/", TossBounty do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/", TossBounty do
    pipe_through [:api, :current_user]

    post "/token", TokenController, :create
    post "/token/refresh", TokenController, :refresh
    get "/github_oauth_url", GitHubOauthUrlController, :show
  end

  scope "/", TossBounty do
    pipe_through [:api, :bearer_auth, :current_user]

    resources "/users", UserController, only: [:create, :show]
    resources "/addresses", AddressController, except: [:new, :edit]
    resources "/contact_infos", ContactInfoController, except: [:new, :edit]
    resources "/boards", BoardController, except: [:new, :edit]
    resources "/agreements", AgreementController, except: [:new, :edit]
    resources "/agreement_signers", AgreementSignerController, except: [:new, :edit]
    resources "/message_threads", MessageThreadController, except: [:new, :edit]
    resources "/messages", MessageController, except: [:new, :edit]
    resources "/skills", SkillController, except: [:new, :edit]
    resources "/skills_users", SkillUserController, except: [:new, :edit]
    resources "/subscribers", SubscriberController, except: [:new, :edit]
  end
end
