defmodule TossBountyWeb.PlanView do
  use TossBountyWeb.Web, :view
  use JaSerializer.PhoenixView

  attributes([:uuid])

  has_one(
    :user,
    field: :reward_id,
    type: "reward"
  )

  def render("403.json-api", %{message: message}) do
    %{
      errors: [
        %{
          id: "FORBIDDEN",
          title: "403 Forbidden",
          detail: message,
          status: 403
        }
      ]
    }
  end

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
