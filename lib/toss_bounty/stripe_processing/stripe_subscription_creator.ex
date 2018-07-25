defmodule TossBounty.StripeProcessing.StripeSubscriptionCreator do
  @behaviour TossBountyWeb.SubscriptionController.Behaviour
  alias TossBounty.StripeProcessing.Plan
  alias TossBounty.StripeProcessing.Customer
  alias TossBounty.Repo

  def create(%{
        "customer_id" => customer_id,
        "plan_id" => plan_id,
        "stripe_external_id" => stripe_external_id,
        "type" => "subscription"
      }) do
    customer = Repo.get_by(Customer, id: customer_id)
    plan = Repo.get_by(Plan, id: plan_id)

    Stripe.Subscription.create(
      %{
        customer: customer.uuid,
        plan: plan.uuid,
        application_fee_percent: "4"
      },
      connect_account: stripe_external_id
    )
    |> IO.inspect()
  end
end
