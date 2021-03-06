defmodule TossBountyWeb.GithubRepoController do
  use TossBountyWeb.Web, :controller
  alias TossBounty.Github.GithubRepo

  action_fallback(TossBountyWeb.FallbackController)

  def index(conn, %{"user_id" => user_id}) do
    github_repos = TossBounty.Github.list_github_repos(%{"user_id" => user_id})
    render(conn, "index.json-api", data: github_repos)
  end

  def index(conn, _params) do
    github_repos = TossBounty.Github.list_github_repos()
    render(conn, "index.json-api", data: github_repos)
  end

  def show(conn, %{"id" => id}) do
    github_repo = TossBounty.Github.get_github_repo!(id)
    render(conn, "show.json-api", data: github_repo)
  end
end
