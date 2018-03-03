defmodule TossBountyWeb.UserView do
  use TossBountyWeb.Web, :view
  use JaSerializer.PhoenixView

  attributes([
    :name,
    :email,
    :stripe_external_id,
    :stripe_access_token,
    :stripe_external_id,
    :role
  ])
end
