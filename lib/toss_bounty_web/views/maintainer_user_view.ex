defmodule TossBountyWeb.MaintainerUserView do
  use TossBountyWeb.Web, :view
  use JaSerializer.PhoenixView

  attributes([
    :name,
    :stripe_external_id
  ])
end
