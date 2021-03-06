defmodule TossBountyWeb.PlanController do
  use TossBountyWeb.Web, :controller
  alias TossBounty.StripeProcessing.Plan
  alias TossBounty.StripeProcessing
  alias TossBounty.Accounts.User
  alias JaSerializer.Params
  alias TossBounty.SubscriptionController

  @plan_creator Application.fetch_env!(:toss_bounty, :plan_creator)
  @plan_deleter Application.fetch_env!(:toss_bounty, :plan_deleter)
  @plan_updater Application.fetch_env!(:toss_bounty, :plan_updater)

  defmodule Behaviour do
    @callback create(Map.t()) :: :ok
    @callback delete(TossBounty.StripeProcessing.Plan.t()) :: :ok
  end

  action_fallback(TossBountyWeb.FallbackController)

  def index(conn, %{"campaign_id" => campaign_id}) do
    plans = StripeProcessing.list_plans(%{"campaign_id" => campaign_id})

    render(conn, "index.json-api", plans: plans)
  end

  def index(conn, %{"subscriber_id" => subscriber_id}) do
    plans = StripeProcessing.list_plans(%{"subscriber_id" => subscriber_id})

    render(conn, "index.json-api", plans: plans)
  end

  def index(conn, _params) do
    plans = StripeProcessing.list_plans()
    render(conn, "index.json-api", plans: plans)
  end

  def show(conn, %{"id" => id}) do
    plan =
      id
      |> StripeProcessing.get_plan!()

    render(conn, "show.json-api", plan: plan)
  end

  def create(conn, %{"data" => data = %{"type" => "plan", "relationships" => _relationships}}) do
    attrs =
      data
      |> Params.to_attributes()
      |> create_plan_in_stripe

    with {:ok, %Plan{} = plan} <- StripeProcessing.create_plan(attrs) do
      conn
      |> put_status(:created)
      |> render("show.json-api", data: plan)
    end
  end

  def create(conn, %{"data" => data = %{"type" => "plan"}}) do
    conn
    |> put_status(:unprocessable_entity)
    |> render("relationships-errors.json-api")
  end

  defp user_from_reward(attrs) do
    reward_id = attrs["reward_id"]

    query =
      from(
        u in User,
        join: c in assoc(u, :campaigns),
        join: r in assoc(c, :rewards),
        where: r.id == ^reward_id
      )

    Repo.one(query)
  end

  defp create_plan_in_stripe(attrs) do
    user = user_from_reward(attrs)

    updated_attrs =
      attrs
      |> Enum.into(%{"stripe_external_id" => user.stripe_external_id})

    {:ok, stripe_plan} = @plan_creator.create(updated_attrs)

    attrs
    |> Enum.into(%{"uuid" => stripe_plan.id})
  end

  def update(conn, %{
        "id" => id,
        "data" => data = %{"type" => "plan", "attributes" => plan_params}
      }) do
    plan = StripeProcessing.get_plan!(id)

    preloaded_plan = Repo.preload(plan, [:reward])
    reward = preloaded_plan.reward
    preloaded_reward = Repo.preload(reward, [:campaign])
    campaign = preloaded_reward.campaign
    preloaded_campaign = Repo.preload(campaign, [:user])
    user = preloaded_campaign.user
    connect_account = user.stripe_external_id

    attrs =
      data
      |> Params.to_attributes()

    current_user = conn.assigns[:current_user]

    case update_plan_in_stripe(conn, attrs, plan.uuid, connect_account) do
      {:error, %Stripe.APIErrorResponse{} = response} ->
        conn
        |> put_status(404)
        |> render("404.json-api", %{message: response.message})

      {:ok, %Stripe.Plan{id: id}} ->
        case TossBounty.Policy.authorize(current_user, :administer, plan, attrs) do
          {:ok, :authorized} ->
            with {:ok, %Plan{} = plan} <- StripeProcessing.update_plan(plan, plan_params) do
              render(conn, "show.json-api", plan: plan)
            end

          {:error, :not_authorized} ->
            message =
              "User with id: #{current_user.id} is not authorized " <>
                "to administer plan with id: #{plan.id}"

            conn
            |> put_status(403)
            |> render("403.json-api", %{message: message})
        end
    end
  end

  defp update_plan_in_stripe(conn, attrs, uuid, connect_account) do
    @plan_updater.update(conn, attrs, uuid, connect_account)
  end

  def delete(conn, %{"id" => id}) do
    plan = StripeProcessing.get_plan!(id)

    current_user =
      conn
      |> TossBounty.UserManager.Guardian.Plug.current_resource()

    preloaded_plan =
      plan
      |> Repo.preload([:subscriptions])

    subscriptions = preloaded_plan.subscriptions

    subscriptions
    |> Enum.each(fn subscription -> delete_subscriptions_in_stripe(conn, subscription) end)

    connect_account = current_user.stripe_external_id

    case delete_plan_in_stripe(conn, plan.uuid, connect_account) do
      {:error, %Stripe.APIErrorResponse{} = response} ->
        conn
        |> put_status(404)
        |> render("404.json-api", %{message: response.message})

      {:ok, %Stripe.Plan{id: id}} ->
        case TossBounty.Policy.authorize(current_user, :administer, plan) do
          {:ok, :authorized} ->
            with {:ok, %Plan{}} <- StripeProcessing.delete_plan(plan) do
              send_resp(conn, :no_content, "")
            end

          {:error, :not_authorized} ->
            message =
              "User with id: #{current_user.id} is not authorized " <>
                "to administer plan with id: #{plan.id}"

            conn
            |> put_status(403)
            |> render("403.json-api", %{message: message})
        end
    end
  end

  defp delete_plan_in_stripe(conn, plan_id, connect_account) do
    @plan_deleter.delete(conn, plan_id, connect_account)
  end

  def delete_subscriptions_in_stripe(conn, subscription) do
    TossBountyWeb.SubscriptionController.delete(conn, %{"id" => subscription.id})
  end
end
