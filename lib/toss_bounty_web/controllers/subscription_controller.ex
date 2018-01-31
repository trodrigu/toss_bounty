defmodule TossBountyWeb.SubscriptionController do
  use TossBountyWeb.Web, :controller
  alias TossBounty.StripeProcessing.Subscription
  alias TossBounty.StripeProcessing
  alias JaSerializer.Params

  @subscription_creator Application.fetch_env!(:toss_bounty, :subscription_creator)
  @subscription_deleter Application.fetch_env!(:toss_bounty, :subscription_deleter)

  defmodule Behaviour do
    @callback create(Map.t()) :: :ok
    @callback delete(TossBounty.StripeProcessing.Subscription.t()) :: :ok
  end

  action_fallback(TossBountyWeb.FallbackController)

  def create(conn, %{
        "data" => data = %{"type" => "subscription", "relationships" => _relationships}
      }) do
    attrs =
      data
      |> Params.to_attributes()
      |> create_subscription_in_stripe

    with {:ok, %Subscription{} = subscription} <- StripeProcessing.create_subscription(attrs) do
      conn
      |> put_status(:created)
      |> render("show.json-api", data: subscription)
    end
  end

  def create(conn, %{"data" => data = %{"type" => "subscription"}}) do
    conn
    |> put_status(:unprocessable_entity)
    |> render("relationships-errors.json-api")
  end

  defp create_subscription_in_stripe(attrs) do
    {:ok, stripe_subscription} = @subscription_creator.create(attrs)

    attrs
    |> Enum.into(%{"uuid" => stripe_subscription.id})
  end

  defp delete_subscription_in_stripe(conn, subscription_id) do
    @subscription_deleter.delete(conn, subscription_id)
  end

  def delete(conn, %{"id" => id}) do
    subscription = StripeProcessing.get_subscription!(id)

    current_user = conn.assigns[:current_user]

    case delete_subscription_in_stripe(conn, id) do
      {:error, %Stripe.APIErrorResponse{} = response} ->
        conn
        |> put_status(404)
        |> render("404.json-api", %{message: response.message})

      {:ok, %{deleted: true, id: id}} ->
        case TossBounty.Policy.authorize(current_user, :administer, subscription) do
          {:ok, :authorized} ->
            with {:ok, %Subscription{}} <- StripeProcessing.delete_subscription(subscription) do
              send_resp(conn, :no_content, "")
            end

          {:error, :not_authorized} ->
            message =
              "User with id: #{current_user.id} is not authorized " <>
                "to administer subscription with id: #{subscription.id}"

            conn
            |> put_status(403)
            |> render("403.json-api", %{message: message})
        end
    end
  end
end
