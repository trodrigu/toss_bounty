defmodule TossBountyWeb.GitHubRepoController do
  use TossBountyWeb.Web, :controller
  use JaResource
  alias TossBounty.GitHub.GitHubRepo
  plug JaResource

  def model, do: TossBounty.GitHub.GitHubRepo

  def filter(_conn, query, "user_id", user_id) do
    where(query, user_id: ^user_id)
  end
end
