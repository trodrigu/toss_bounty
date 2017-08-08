defmodule TossBounty.CurrentUser do
  import Plug.Conn
  alias TossBounty.GuardianSerializer

  @spec init(Keyword.t) :: Keyword.t
  def init(opts), do: opts

  @spec call(Plug.Conn.t, Keyword.t) :: Plug.Conn.t
  def call(conn, _opts) do
    case Guardian.Plug.current_resource(conn) do
      user = %TossBounty.User{} ->
        Plug.Conn.assign(conn, :current_user, user)
      nil ->
        conn
    end
  end
end
