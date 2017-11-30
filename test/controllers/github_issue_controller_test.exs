defmodule TossBounty.GitHubIssueControllerTest do
  use TossBounty.ApiCase
  import TossBounty.AuthenticationTestHelpers
  alias TossBounty.GitHubRepo
  alias TossBounty.GitHubIssue
  alias TossBounty.Repo

  setup %{conn: conn} do
    conn =
      conn
      |> put_req_header("accept", "application/vnd.api+json")
      |> put_req_header("content-type", "application/vnd.api+json")

    {:ok, conn: conn}
  end

  describe "index" do
    test "renders index of resources", %{conn: conn} do
      conn = get conn, git_hub_issue_path(conn, :index)
      assert conn |> json_response(200)
    end

    test "filter by repo name returns the correct issues" do
      repo = Repo.insert!(%GitHubRepo{name: "foobar"})
      repo_that_does_not_matter = Repo.insert!(%GitHubRepo{name: "foobar"})
      Repo.insert!(%GitHubIssue{title: "great title", body: "body", github_repo_id: repo.id})
      conn = get conn, git_hub_issue_path(conn, :index), %{ github_repo_id: repo.id }
      response = json_response(conn, 200)
      issue_from_response = response["data"]
      |> Enum.at(0)
      issues_title = issue_from_response["attributes"]["title"]
      assert issues_title == "great title"
    end
  end
end
