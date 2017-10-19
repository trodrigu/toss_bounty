defmodule TossBounty.GitHubOauthUrlController do
  use TossBounty.Web, :controller

  def show(conn, _params) do
    url = GitHub.authorize_url!
    render conn, "show.json", %{ url: url }
  end
end
