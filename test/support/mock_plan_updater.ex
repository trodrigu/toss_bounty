defmodule TossBounty.StripeProcessing.MockStripePlanUpdater do
  @behaviour TossBountyWeb.PlanController.Behaviour

  def update(conn, plan_id) do
    errors = conn.assigns[:errors]

    case errors do
      :none_found ->
        {:error,
         %Stripe.APIErrorResponse{
           code: nil,
           message: "No such plan: plan_CDYHNRRzrjnVTO",
           status_code: 404,
           type: "invalid_request_error"
         }}

      _ ->
        {:ok,
         %Stripe.Plan{
           amount: 100,
           created: 1_517_111_375,
           currency: "usd",
           id: "plan_CDYHNRRzrjnVTO",
           interval: "month",
           interval_count: 1,
           livemode: false,
           metadata: %{},
           name: "some-cool-plan",
           object: "plan",
           statement_descriptor: nil,
           trial_period_days: nil
         }}
    end
  end
end
