defmodule TossBountyWeb.GithubRepoControllerTest do
  use TossBountyWeb.ApiCase
  import TossBountyWeb.AuthenticationTestHelpers
  alias TossBounty.Github.GithubIssue
  alias TossBounty.Github.GithubRepo
  alias TossBounty.Accounts.User

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
    @tag :authenticated
    test "returns an index of the github repos", %{conn: conn} do
      conn = get(conn, github_repo_path(conn, :index))
      assert conn |> json_response(200)
    end

    @tag :authenticated
    test "filter by user id returns the correct repo", %{conn: conn} do
      user = Repo.get_by(User, email: "test@test.com")
      repo = Repo.insert!(%GithubRepo{name: "foobar", user_id: user.id})
      repo_that_does_not_matter = Repo.insert!(%GithubRepo{name: "bazbar"})
      Repo.insert!(%GithubIssue{title: "great title", body: "body", github_repo_id: repo.id})

      user = Repo.one(from(u in User, limit: 1))
      {:ok, jwt, _} = Guardian.encode_and_sign(user)

      conn =
        conn()
        |> put_req_header("authorization", "Bearer #{jwt}")
        |> get(github_repo_path(conn, :index), %{user_id: user.id})

      response = json_response(conn, 200)

      repo_from_response =
        response["data"]
        |> Enum.at(0)

      repos_name = repo_from_response["attributes"]["name"]
      assert repos_name == "foobar"
    end
  end
end
