defmodule TossBounty.StripeProcessing.StripePlanCreator do
  @behaviour TossBountyWeb.PlanController.Behaviour

  def create(attrs) do
    Stripe.Plan.create(attrs)
  end
end
