defmodule TossBountyWeb.SubscriptionController do
  use TossBountyWeb.Web, :controller
  alias TossBounty.StripeProcessing.Subscription
  alias TossBounty.StripeProcessing.Plan
  alias TossBounty.Campaigns
  alias TossBounty.Accounts.User
  alias TossBounty.StripeProcessing
  alias JaSerializer.Params

  @subscription_creator Application.fetch_env!(:toss_bounty, :subscription_creator)
  @subscription_deleter Application.fetch_env!(:toss_bounty, :subscription_deleter)

  defmodule Behaviour do
    @callback create(Map.t()) :: :ok
    @callback delete(TossBounty.StripeProcessing.Subscription.t()) :: :ok
  end

  action_fallback(TossBountyWeb.FallbackController)

  def index(conn, %{"user_id" => user_id}) do
    subscriptions = StripeProcessing.list_subscriptions(%{"user_id" => user_id})
    render(conn, "index.json-api", data: subscriptions)
  end

  def index(conn, _params) do
    subscriptions = StripeProcessing.list_subscriptions()
    render(conn, "index.json-api", data: subscriptions)
  end

  def create(conn, %{
        "data" => data = %{"type" => "subscription", "relationships" => _relationships}
      }) do
    attrs =
      data
      |> Params.to_attributes()
      |> create_subscription_in_stripe

    with {:ok, %Subscription{} = subscription} <- StripeProcessing.create_subscription(attrs) do
      update_campaign(subscription)

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

  defp user_from_plan(attrs) do
    plan_id = attrs["plan_id"]

    query =
      from(
        u in User,
        join: c in assoc(u, :campaigns),
        join: r in assoc(c, :rewards),
        join: p in assoc(r, :plan),
        where: p.id == ^plan_id
      )

    Repo.one(query)
  end

  defp create_subscription_in_stripe(attrs) do
    user = user_from_plan(attrs)

    updated_attrs =
      attrs
      |> Enum.into(%{"stripe_external_id" => user.stripe_external_id})

    {:ok, stripe_subscription} = @subscription_creator.create(updated_attrs)

    attrs
    |> Enum.into(%{"uuid" => stripe_subscription.id})
  end

  defp update_campaign(subscription) do
    preloaded_subscription = Repo.preload(subscription, [:plan])

    plan = preloaded_subscription.plan

    preloaded_plan = Repo.preload(plan, [:reward])

    reward = preloaded_plan.reward

    preloaded_reward = Repo.preload(reward, [:campaign])

    donation_level = reward.donation_level

    campaign = preloaded_reward.campaign

    campaign_current_funding = campaign.current_funding

    updated_current_funding = campaign_current_funding + donation_level

    Campaigns.update_campaign(campaign, %{current_funding: updated_current_funding})
  end

  defp delete_subscription_in_stripe(conn, subscription_id) do
    @subscription_deleter.delete(conn, subscription_id)
  end

  def delete(conn, %{"id" => id}) do
    subscription = StripeProcessing.get_subscription!(id)

    current_user = conn.assigns[:current_user]

    case TossBounty.Policy.authorize(current_user, :administer, subscription) do
      {:ok, :authorized} ->
        case delete_subscription_in_stripe(conn, subscription.uuid) do
          {:error, %Stripe.APIErrorResponse{} = response} ->
            conn
            |> put_status(404)
            |> render("404.json-api", %{message: response.message})

          {:ok, _stripe_subscription} ->
            with {:ok, %Subscription{}} <- StripeProcessing.delete_subscription(subscription) do
              send_resp(conn, :no_content, "")
            end
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
