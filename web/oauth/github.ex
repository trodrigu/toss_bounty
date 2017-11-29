defmodule GitHub do
  @github_impl Application.fetch_env!(:toss_bounty, :github_strategy)
  @moduledoc """
  An OAuth2 strategy for GitHub.
  """
  use OAuth2.Strategy

  alias OAuth2.Strategy.AuthCode

  defmodule Behaviour do
    @callback authorize_url!([params: List.t]) :: :ok
    @callback get_token!([params: List.t, headers: List.t]) :: :ok
    @callback client() :: :ok
    @callback get_user!(Map.t) :: :ok
  end

  # Public API

  def client do
    @github_impl.client
  end

  def authorize_url!(params \\ []) do
    @github_impl.authorize_url!(client(), params)
  end

  def get_token!(params \\ [], headers \\ []) do
    @github_impl.get_token!(client(), Keyword.merge(params, client_secret: client().client_secret))
  end

  # Strategy Callbacks

  def authorize_url(client, params) do
    AuthCode.authorize_url(client, params)
  end

  def get_token(client, params, headers) do
    client
    |> put_header("Accept", "application/json")
    |> AuthCode.get_token(params, headers)
  end

  def get_user!(client) do
    @github_impl.get_user!(client)
  end
end
