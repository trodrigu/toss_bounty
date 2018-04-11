defmodule TossBounty.StripeProcessing.StripeSubscriptionDeleter do
  @behaviour TossBountyWeb.SubscriptionController.Behaviour

  def delete(_conn, subscription_id, connect_account) do
    Stripe.Subscription.delete(subscription_id, %{}, connect_account: connect_account)
  end
end
