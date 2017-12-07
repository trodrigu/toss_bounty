defmodule TossBountyWeb.UserView do
  use TossBountyWeb.Web, :view
  use JaSerializer.PhoenixView

  attributes [:name, :email]
end
