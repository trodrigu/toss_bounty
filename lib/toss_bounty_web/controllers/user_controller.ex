defmodule TossBountyWeb.UserController do
  use TossBountyWeb.Web, :controller
  use JaResource
  alias TossBounty.Accounts.User
  plug JaResource
  plug :login, only: [:create]

  def handle_create(conn, attributes) do
    %User{}
    |> User.registration_changeset(attributes)
  end

  defp login(conn, _opts) do
    Plug.Conn.register_before_send(conn, &do_login(&1))
  end

  defp do_login(conn), do: Plug.Conn.assign(conn, :current_user, conn.assigns[:data])
end
