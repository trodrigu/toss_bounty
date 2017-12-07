defmodule TossBountyWeb.GitHubOauthUrlController do
  use TossBountyWeb.Web, :controller

  def show(conn, _params) do
    url = GitHub.authorize_url!(scope: "user,public_repo")
    render conn, "show.json", %{ url: url }
  end
end
