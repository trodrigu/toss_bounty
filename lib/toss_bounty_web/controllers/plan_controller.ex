defmodule TossBountyWeb.PlanController do
  use TossBountyWeb.Web, :controller
  alias TossBounty.StripeProcessing.Plan
  alias TossBounty.StripeProcessing
  alias JaSerializer.Params

  @plan_creator Application.fetch_env!(:toss_bounty, :plan_creator)

  defmodule Behaviour do
    @callback create(Map.t()) :: :ok
    @callback delete(TossBounty.StripeProcessing.Plan.t()) :: :ok
  end

  action_fallback(TossBountyWeb.FallbackController)

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

  defp create_plan_in_stripe(attrs) do
    {:ok, stripe_plan} = @plan_creator.create(attrs)

    attrs
    |> Enum.into(%{"uuid" => stripe_plan.id})
  end

  def delete(conn, %{"id" => id}) do
    plan = StripeProcessing.get_plan!(id)

    current_user = conn.assigns[:current_user]

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
