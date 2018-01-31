defmodule TossBountyWeb.GithubOauthUrlController do
  use TossBountyWeb.Web, :controller

  def show(conn, _params) do
    url = Github.authorize_url!(scope: "user,public_repo")
    render(conn, "show.json", %{url: url})
  end
end
