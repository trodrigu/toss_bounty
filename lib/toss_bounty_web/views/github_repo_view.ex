defmodule TossBountyWeb.GitHubRepoView do
  use TossBountyWeb.Web, :view
  use JaSerializer.PhoenixView

  attributes [:name]
end