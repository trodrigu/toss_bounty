defmodule TossBountyWeb.GitHubIssueControllerTest do
  use TossBountyWeb.ApiCase
  import TossBountyWeb.AuthenticationTestHelpers
  alias TossBountyWeb.GitHubRepo
  alias TossBountyWeb.GitHubIssue
  alias TossBounty.User
  alias TossBounty.Repo

  setup %{conn: conn} do
    conn =
      conn
      |> put_req_header("accept", "application/vnd.api+json")
      |> put_req_header("content-type", "application/vnd.api+json")

    {:ok, conn: conn}
  end

  describe "index" do
    @tag :authenticated
    test "renders index of resources", %{conn: conn} do
      conn = get conn, git_hub_issue_path(conn, :index)
      assert conn |> json_response(200)
    end

    @tag :authenticated
    test "filter by repo id returns the correct issues", %{conn: conn} do
      repo = Repo.insert!(%GitHubRepo{name: "foobar"})
      Repo.insert!(%GitHubIssue{title: "great title", body: "body", github_repo_id: repo.id})
      Repo.insert!(%GitHubIssue{title: "wrong title", body: "body", github_repo_id: repo.id})

      user = Repo.one(from u in User, limit: 1)
      {:ok, jwt, _} = Guardian.encode_and_sign(user)

      conn =
        conn()
        |> put_req_header("authorization", "Bearer #{jwt}")
        |> get git_hub_issue_path(conn, :index), %{ github_repo_id: repo.id }

      response = json_response(conn, 200)
      issue_from_response = response["data"]
      |> Enum.at(0)
      issues_title = issue_from_response["attributes"]["title"]
      assert issues_title == "great title"
    end
  end
end
