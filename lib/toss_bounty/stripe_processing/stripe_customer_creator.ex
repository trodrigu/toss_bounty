defmodule TossBounty.StripeProcessing.StripeCustomerCreator do
  @behaviour TossBountyWeb.CustomerController.Behaviour

  alias Stripe.Source

  def create(%{source: source}) do
    Stripe.Customer.create(%{source: source})
  end
end
