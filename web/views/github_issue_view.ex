defmodule TossBounty.GitHubIssueView do
  use TossBounty.Web, :view
  use JaSerializer.PhoenixView

  attributes [:title, :body]
end
