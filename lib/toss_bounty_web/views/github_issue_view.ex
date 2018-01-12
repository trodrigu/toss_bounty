defmodule TossBountyWeb.GithubIssueView do
  use TossBountyWeb.Web, :view
  use JaSerializer.PhoenixView

  attributes [:title, :body]
end
