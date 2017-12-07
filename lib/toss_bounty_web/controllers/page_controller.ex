defmodule TossBountyWeb.PageController do
  use TossBountyWeb.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
