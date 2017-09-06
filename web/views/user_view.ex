defmodule TossBounty.UserView do
  use TossBounty.Web, :view
  use JaSerializer.PhoenixView

  attributes [:name, :email]
end
