defmodule TossBounty.UserView do
  use TossBounty.Web, :view
  use JaSerializer.PhoenixView

  attributes [:name, :username, :email]
end
