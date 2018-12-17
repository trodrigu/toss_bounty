defmodule TossBounty.Accounts.CurrentUser do
  import Plug.Conn
  alias TossBounty.GuardianSerializer

  def init(opts), do: opts

  def call(conn, _opts) do
    case TossBounty.UserManager.Guardian.Plug.current_resource(conn) do
      user = %TossBounty.Accounts.User{} ->
        Plug.Conn.assign(conn, :current_user, user)

      nil ->
        conn
    end
  end
end
