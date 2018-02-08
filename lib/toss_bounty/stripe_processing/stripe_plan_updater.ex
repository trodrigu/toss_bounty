defmodule TossBounty.StripeProcessing.StripePlanUpdater do
  @behaviour TossBountyWeb.PlanController.Behaviour

  def update(attrs) do
    Stripe.Plan.update(attrs)
  end
end
