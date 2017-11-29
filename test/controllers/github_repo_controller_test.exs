defmodule TossBounty.GitHubRepoControllerTest do
  use TossBounty.ApiCase
  import TossBounty.AuthenticationTestHelpers
  setup config = %{conn: conn} do
    if email = config[:login_as] do
      user = insert_user(email: "test@test.com")
      conn =
        %{build_conn() | host: "api."}
        |> put_req_header("accept", "application/vnd.api+json")
        |> put_req_header("content-type", "application/vnd.api+json")
        |> assign(:current_user, user)

      {:ok, conn: conn, user: user}
    else
      :ok
    end

  end

  describe "index" do
    @tag login_as: "max"
    test "returns an index of the github repos", %{conn: conn} do
      conn = get conn, github_repo_path(conn, :index)
      assert conn |> json_response(200)
    end
  end
end
