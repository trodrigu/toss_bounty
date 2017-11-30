defmodule TossBounty.GitHubIssueController do
  use TossBounty.Web, :controller
  use JaResource
  alias TossBounty.GitHubRepo
  plug JaResource
end
