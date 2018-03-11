defmodule TossBounty.StripeProcessing.StripePlanCreator do
  @behaviour TossBountyWeb.PlanController.Behaviour

  def create(attrs) do
    connect_account = attrs["stripe_external_id"]
    Stripe.Plan.create(attrs, connect_account: connect_account)
  end
end
