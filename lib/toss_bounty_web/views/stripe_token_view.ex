defmodule TossBountyWeb.StripeTokenView do
  use TossBountyWeb.Web, :view
  use JaSerializer.PhoenixView

  attributes([:uuid])

  has_one(
    :user,
    field: :user_id,
    type: "user"
  )
end
