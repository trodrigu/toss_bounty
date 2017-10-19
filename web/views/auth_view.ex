defmodule TossBounty.AuthView do
  use TossBounty.Web, :view

  def render("show.json", %{token: token}) do
    %{
      token: token
    }
  end
end
