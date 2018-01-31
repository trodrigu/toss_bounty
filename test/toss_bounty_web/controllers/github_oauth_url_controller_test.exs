defmodule TossBountyWeb.GithubOauthUrlControllerTest do
  use TossBountyWeb.ConnCase

  alias TossBountyWeb.Github

  setup do
    conn =
      build_conn()
      |> put_req_header("accept", "application/vnd.api+json")
      |> put_req_header("content-type", "application/vnd.api+json")

    {:ok, conn: conn}
  end

  test "shows the url", %{conn: conn} do
    conn = get(conn, github_oauth_url_path(conn, :show))
    data = json_response(conn, 200)["data"]
    url = data["attributes"]["url"]
    uri = URI.parse(url)
    assert uri.host == "github.com"
  end
end
