defmodule TossBounty.StripeProcessing.StripeSubscriptionDeleter do
  @behaviour TossBountyWeb.SubscriptionController.Behaviour

  def delete(_conn, subscription_id) do
    Stripe.Subscription.delete(subscription_id)
  end
end
