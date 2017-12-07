defmodule TossBountyWeb.GitHubRepoController do
  use TossBountyWeb.Web, :controller
  use JaResource
  alias TossBountyWeb.GitHubRepo
  plug JaResource

  def filter(_conn, query, "user_id", user_id) do
    where(query, user_id: ^user_id)
  end
end
