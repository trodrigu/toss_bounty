defmodule TossBounty.GitHubRepoController do
  use TossBounty.Web, :controller
  use JaResource
  alias TossBounty.GitHubRepo
  plug JaResource

  def filter(_conn, query, "user_id", user_id) do
    where(query, user_id: ^user_id)
  end
end
