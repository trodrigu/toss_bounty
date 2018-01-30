defmodule TossBountyWeb.PlanController do
  use TossBountyWeb.Web, :controller
  alias TossBounty.StripeProcessing.Plan
  alias TossBounty.StripeProcessing
  alias JaSerializer.Params

  @plan_creator Application.fetch_env!(:toss_bounty, :plan_creator)

  defmodule Behaviour do
    @callback create(Map.t()) :: :ok
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
end
