defmodule TossBountyWeb.StripeTokenController do
  use TossBountyWeb.Web, :controller
  alias JaSerializer.Params
  alias TossBounty.Accounts.CurrentUser
  alias TossBounty.StripeProcessing
  alias TossBounty.StripeProcessing.Token
  action_fallback(TossBountyWeb.FallbackController)

  def create(conn, %{"data" => data = %{"type" => "token", "attributes" => token_params}}) do
    attrs =
      Params.to_attributes(data)
      |> IO.inspect()

    with {:ok, %Token{} = token} <- StripeProcessing.create_token(attrs) do
      conn
      |> put_status(:created)
      |> render("show.json-api", data: token)
    end
  end
end
