defmodule TossBounty.GitHubOauthUrlView do
  use TossBounty.Web, :view

  def render("show.json", %{ url: url }) do
    %{data: %{ attributes: %{ url: url }}}
  end
end
