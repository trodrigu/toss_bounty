defmodule TossBountyWeb.GithubRepoController do
  use TossBountyWeb.Web, :controller
  use JaResource
  alias TossBounty.GitHub.GithubRepo
  plug JaResource

  def model, do: TossBounty.GitHub.GithubRepo

  def filter(_conn, query, "user_id", user_id) do
    where(query, user_id: ^user_id)
  end
end
