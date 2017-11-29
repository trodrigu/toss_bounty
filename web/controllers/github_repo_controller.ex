defmodule TossBounty.GitHubRepoController do
  use TossBounty.Web, :controller
  use JaResource
  alias TossBounty.GitHubRepo
  plug JaResource
end
