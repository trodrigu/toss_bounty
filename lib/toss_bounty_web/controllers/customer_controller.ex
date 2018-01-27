defmodule TossBountyWeb.CustomerController do
  use TossBountyWeb.Web, :controller
  alias JaSerializer.Params
  alias TossBounty.Accounts.CurrentUser
  alias TossBounty.StripeProcessing
  alias TossBounty.StripeProcessing.Customer
  action_fallback(TossBountyWeb.FallbackController)

  def create(conn, %{"data" => data = %{"type" => "customer", "attributes" => customer_params}}) do
    attrs = Params.to_attributes(data)

    with {:ok, %Customer{} = customer} <- StripeProcessing.create_customer(attrs) do
      conn
      |> put_status(:created)
      |> render("show.json-api", data: customer)
    end
  end
end
