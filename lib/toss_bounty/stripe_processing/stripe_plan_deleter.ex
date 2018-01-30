defmodule TossBounty.StripeProcessing.StripePlanDeleter do
  @behaviour TossBountyWeb.PlanController.Behaviour

  def delete(plan_id) do
    Stripe.Plan.delete(plan_id)
  end
end
