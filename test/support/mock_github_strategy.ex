defmodule TossBounty.MockGithubStrategy do
  @behaviour TossBounty.Github.Behaviour

  defmodule Client do
    defstruct token: %AccessToken{}
  end

  defmodule AccessToken do
    defstruct access_token: nil
  end

  def client, do: %Client{}

  def get_token!(_provider, _code), do: client

  def authorize_url!(_params), do: "https://authorize-url.com"

  def get_user!(_client) do
    %{name: "test_user", avatar: "https://avatar-url.com", email: "test@test.com"}
  end
end
