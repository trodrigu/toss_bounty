defmodule TossBountyWeb.ChargeView do
  use TossBountyWeb.Web, :view

  def render("show.json", %{type: type, message: message, source: source}) do
    %{data: %{type: type, attributes: %{message: message, source: source}}}
  end
end
