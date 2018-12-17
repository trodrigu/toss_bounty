defmodule TossBountyWeb.AuthenticationTestHelpers do
  use Phoenix.ConnTest

  def authenticate(conn, user) do
    {:ok, jwt, _} = TossBounty.UserManager.Guardian.encode_and_sign(user)

    conn
    |> put_req_header("authorization", "Bearer #{jwt}")
    |> Plug.Conn.assign(:current_user, user)
  end
end
