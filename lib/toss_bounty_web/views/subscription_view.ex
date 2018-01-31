defmodule TossBountyWeb.SubscriptionView do
  use TossBountyWeb.Web, :view
  use JaSerializer.PhoenixView

  attributes([:uuid])

  has_one(
    :plan,
    field: :plan_id,
    type: "plan"
  )

  has_one(
    :customer,
    field: :customer_id,
    type: "customer"
  )

  def render("404.json-api", %{message: message}) do
    %{
      errors: [
        %{
          id: "NOT FOUND",
          title: "404 Not Found",
          detail: message,
          status: 404
        }
      ]
    }
  end

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
