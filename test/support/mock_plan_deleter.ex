defmodule TossBounty.StripeProcessing.MockStripePlanDeleter do
  @behaviour TossBountyWeb.PlanController.Behaviour

  def delete(conn, plan_id, _connect_account) do
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
           amount: nil,
           created: nil,
           currency: nil,
           id: "plan_DFqHYy1R501ENI",
           interval_count: nil,
           livemode: nil,
           metadata: nil,
           name: nil,
           object: "plan",
           statement_descriptor: nil,
           trial_period_days: nil
         }}
    end
  end
end
