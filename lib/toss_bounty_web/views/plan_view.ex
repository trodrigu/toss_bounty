defmodule TossBountyWeb.PlanView do
  use TossBountyWeb.Web, :view
  use JaSerializer.PhoenixView

  attributes([:uuid])

  has_one(
    :user,
    field: :reward_id,
    type: "reward"
  )

  def render("relationships-errors.json-api", _message) do
    %{
      errors: [
        %{
          relationships: "can't be blank"
        }
      ]
    }
  end
end
