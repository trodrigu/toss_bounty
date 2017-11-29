defmodule TossBounty.GithubRepoView do
  use TossBounty.Web, :view
  use JaSerializer.PhoenixView

  attributes [:name]
end
