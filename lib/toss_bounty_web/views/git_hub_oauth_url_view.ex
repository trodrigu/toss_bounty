defmodule TossBountyWeb.GithubOauthUrlView do
  use TossBountyWeb.Web, :view

  def render("show.json", %{url: url}) do
    %{data: %{attributes: %{url: url}}}
  end
end
