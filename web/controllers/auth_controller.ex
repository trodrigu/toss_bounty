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

    user_from_db = Repo.get_by(User, email: email)
    user = sign_up_or_return_user(user_from_db, email)

    {:ok, token, _claims} =
      user
      |> Guardian.encode_and_sign(:token)
    conn
    |> Plug.Conn.assign(:current_user, user)
    |> redirect(external: "http://localhost:8000/#/save-session/?token=#{token}&email=#{email}")
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
