defmodule TossBounty.StripeProcessing.StripePlanDeleter do
  @behaviour TossBountyWeb.PlanController.Behaviour

  def delete(_conn, plan_id, connect_account) do
    Stripe.Plan.delete(plan_id, connect_account: connect_account)
  end
end
