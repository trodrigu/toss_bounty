defmodule TossBounty.StripeProcessing.StripeSubscriptionDeleter do
  @behaviour TossBountyWeb.SubscriptionController.Behaviour

  def delete(subscription_id) do
    Stripe.Subscription.delete(subscription_id)
  end
end
