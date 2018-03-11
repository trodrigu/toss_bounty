defmodule TossBountyWeb.MaintainerUserView do
  use TossBountyWeb.Web, :view
  use JaSerializer.PhoenixView

  attributes([
    :email,
    :stripe_external_id
  ])
end
