defmodule TossBounty.StripeProcessing.StripeCustomerCreator do
  @behaviour TossBountyWeb.CustomerController.Behaviour

  def create(source) do
    Stripe.Customer.create(%{source: source})
  end
end
