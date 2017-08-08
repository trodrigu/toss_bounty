defmodule TossBounty.PageController do
  use TossBounty.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
