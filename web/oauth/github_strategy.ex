defmodule TossBounty.GithubStrategy do
  @behaviour TossBounty.Github

  def authorize_url!(client, params \\ []) do
    OAuth2.Client.authorize_url!(client, params)
  end

  def get_token!(client, params \\ []) do
    OAuth2.Client.get_token!(client(), Keyword.merge(params, client_secret: client().client_secret))
  end

  def get_user!(client) do
    %{body: user} = OAuth2.Client.get!(client, "/user")
    %{name: user["name"], avatar: user["avatar_url"], email: user["email"]}
  end

  def client do
    Application.get_env(:oauth2, GitHub)
    |> Keyword.merge(config())
    |> OAuth2.Client.new()
  end

  defp config do
    [strategy: GitHub,
     site: "https://api.github.com",
     authorize_url: "https://github.com/login/oauth/authorize",
     token_url: "https://github.com/login/oauth/access_token"]
  end
end
