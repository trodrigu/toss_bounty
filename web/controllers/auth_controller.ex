defmodule TossBounty.AuthController do
  use TossBounty.Web, :controller
  alias TossBounty.User

  @doc """
  This action is reached via `/auth/:provider/callback` is the the callback URL that
  the OAuth2 provider will redirect the user back to with a `code` that will
  be used to request an access token. The access token will then be used to
  access protected resources on behalf of the user.
  """
  def callback(conn, %{"provider" => provider, "code" => code}) do
    # Exchange an auth code for an access token
    client = get_token!(provider, code)

    user_data_from_response = get_user!(provider, client)

    email = user_data_from_response[:email]
    github_token = client.token.access_token

    user_from_db = Repo.get_by(User, email: email)
    user = sign_up_or_return_user(user_from_db, email)

    user_with_updated_github_token = update_user_with_github_token(user, github_token)

    {:ok, token, _claims} =
      user_with_updated_github_token
      |> Guardian.encode_and_sign(:token)
    conn
    |> Plug.Conn.assign(:current_user, user_with_updated_github_token)
    |> redirect(external: "http://localhost:8000/#/save-session/?token=#{token}&email=#{email}")
  end

  defp update_user_with_github_token(user, github_token) do
    user = Ecto.Changeset.change user, github_token: github_token
    with {:ok, user} <- Repo.update(user), do: user
  end

  defp sign_up_or_return_user(user, email) when is_nil(user) do
    with {:ok, user} <- Repo.insert!(%User{email: email}), do: user
  end
  defp sign_up_or_return_user(user, _email), do: user

  defp authorize_url!("github"), do: GitHub.authorize_url!

  defp get_token!("github", code), do: GitHub.get_token!(code: code)

  defp get_user!("github", client) do
    %{body: user} = OAuth2.Client.get!(client, "/user")
    %{name: user["name"], avatar: user["avatar_url"], email: user["email"]}
  end
end
