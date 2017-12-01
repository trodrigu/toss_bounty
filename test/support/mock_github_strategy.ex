defmodule TossBounty.MockGithubStrategy do
  @behaviour TossBounty.Github.Behaviour

  defmodule Client do
    defstruct token: nil, client_secret: "not-so-secret"
  end

  defmodule AccessToken do
    defstruct access_token: ""
  end

  def client, do: %Client{}

  def get_token!(_provider, _code) do
    Map.put(client, :token, %AccessToken{access_token: "open-sesame"})
  end

  def authorize_url!(_client, _params), do: "https://github.com"

  def get_user!(_client) do
    %{name: "test_user", avatar: "https://avatar-url.com", email: "test@test.com"}
  end
end
