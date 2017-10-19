defmodule TossBounty.AuthController do
  use TossBounty.Web, :controller

  @doc """
  This action is reached via `/auth/:provider/callback` is the the callback URL that
  the OAuth2 provider will redirect the user back to with a `code` that will
  be used to request an access token. The access token will then be used to
  access protected resources on behalf of the user.
  """
  def callback(conn, %{"provider" => provider, "code" => code}) do
    # Exchange an auth code for an access token
    client = get_token!(provider, code)

    # Request the user's data with the access token
    user = get_user!(provider, client)

    # Check to see if user exists
    # if not create a new one do
    {:ok, token, _claims} =
      user
      |> Guardian.encode_and_sign(:token)
    conn
    |> Plug.Conn.assign(:current_user, user)
    |> put_status(:created)
    |> render("show.json", token: token)
  end

  defp authorize_url!("github"), do: GitHub.authorize_url!

  defp get_token!("github", code), do: GitHub.get_token!(code: code)

  defp get_user!("github", client) do
    %{body: user} = OAuth2.Client.get!(client, "/user")
    %{name: user["name"], avatar: user["avatar_url"]}
  end
end
