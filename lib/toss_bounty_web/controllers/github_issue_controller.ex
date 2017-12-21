defmodule TossBountyWeb.GitHubIssueController do
  use TossBountyWeb.Web, :controller
  use JaResource
  alias TossBounty.GitHubRepo
  plug JaResource

  def filter(_conn, query, "github_repo_id", github_repo_id) do
    where(query, github_repo_id: ^github_repo_id)
  end
end
