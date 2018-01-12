defmodule TossBountyWeb.GithubIssueController do
  use TossBountyWeb.Web, :controller
  use JaResource
  alias TossBounty.GitHub.GithubIssue
  plug JaResource

  def model, do: GithubIssue

  def filter(_conn, query, "github_repo_id", github_repo_id) do
    where(query, github_repo_id: ^github_repo_id)
  end
end
