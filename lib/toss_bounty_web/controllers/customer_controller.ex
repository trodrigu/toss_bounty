defmodule TossBountyWeb.CustomerController do
  use TossBountyWeb.Web, :controller
  alias JaSerializer.Params
  alias TossBounty.Accounts.CurrentUser
  alias TossBounty.StripeProcessing
  alias TossBounty.StripeProcessing.Customer
  alias TossBounty.StripeProcessing.Token
  action_fallback(TossBountyWeb.FallbackController)
  @customer_creator Application.fetch_env!(:toss_bounty, :customer_creator)

  defmodule Behaviour do
    @callback create(Map.t()) :: :ok
  end

  def create(conn, %{"data" => data = %{"type" => "customer", "relationships" => _relationships}}) do
    attrs =
      data
      |> Params.to_attributes()
      |> create_customer_in_stripe

    with {:ok, %Customer{} = customer} <- StripeProcessing.create_customer(attrs) do
      conn
      |> put_status(:created)
      |> render("show.json-api", data: customer)
    end
  end

  def create(conn, %{"data" => data = %{"type" => "customer"}}) do
    conn
    |> put_status(:unprocessable_entity)
    |> render("relationships-errors.json-api")
  end

  defp create_customer_in_stripe(attrs) do
    token_id = attrs["token_id"]
    token = Repo.get_by(Token, id: token_id)
    uuid = token.uuid
    {:ok, stripe_customer} = @customer_creator.create(%{source: uuid})

    attrs
    |> Enum.into(%{"uuid" => stripe_customer.id})
  end
end
