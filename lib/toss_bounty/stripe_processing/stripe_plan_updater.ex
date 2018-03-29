defmodule TossBounty.StripeProcessing.StripePlanUpdater do
  @behaviour TossBountyWeb.PlanController.Behaviour

  def update(conn, attrs, uuid, connect_account) do
    name = attrs["name"]

    Stripe.Plan.update(uuid, %{name: name}, connect_account: connect_account)
  end
end
