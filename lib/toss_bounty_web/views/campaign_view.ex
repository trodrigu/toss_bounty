defmodule TossBountyWeb.CampaignView do
  use TossBountyWeb.Web, :view
  use JaSerializer.PhoenixView

  attributes [:current_funding, :funding_end_date, :funding_goal, :long_description, :short_description, :inserted_at, :updated_at]

  has_one :user,
    field: :user_id,
    type: "user"
end
