defmodule TossBounty.StripeProcessing.StripeCustomerCreator do
  @behaviour TossBountyWeb.CustomerController.Behaviour

  alias Stripe.Source

  def create(%{source: source, stripe_external_id: stripe_external_id}) do
    Stripe.Customer.create(%{source: source}, connect_account: stripe_external_id)
  end
end
