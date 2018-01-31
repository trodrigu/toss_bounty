defmodule TossBounty.StripeProcessing.StripeSubscriptionCreator do
  @behaviour TossBountyWeb.SubscriptionController.Behaviour

  def create(attrs) do
    Stripe.Subscription.create(attrs)
  end
end
