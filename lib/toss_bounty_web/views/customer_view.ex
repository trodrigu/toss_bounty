defmodule TossBountyWeb.CustomerView do
  use TossBountyWeb.Web, :view
  use JaSerializer.PhoenixView

  attributes([:uuid])

  has_one(
    :user,
    field: :user_id,
    type: "user"
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
