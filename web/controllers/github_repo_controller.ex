defmodule TossBounty.GithubRepoController do
  use TossBounty.Web, :controller
  use JaResource
  alias TossBounty.GithubRepo
  plug JaResource
end
