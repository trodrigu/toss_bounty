defmodule TossBounty.StripeProcessing.MockStripeSubscriptionCreator do
  @behaviour TossBountyWeb.PlanController.Behaviour

  def create(_attrs) do
    {:ok,
     %Stripe.Subscription{
       application_fee_percent: nil,
       cancel_at_period_end: false,
       canceled_at: nil,
       created: 1_517_111_396,
       current_period_end: 1_519_789_796,
       current_period_start: 1_517_111_396,
       customer: "cus_CDYFyxfPuKA48s",
       ended_at: nil,
       id: "sub_CDYHTSxzZ2SXU8",
       livemode: false,
       metadata: %{},
       object: "subscription",
       plan: %Stripe.Plan{
         amount: 100,
         created: 1_517_111_375,
         currency: "usd",
         id: "plan_CDYHNRRzrjnVTO",
         interval: "month",
         interval_count: 1,
         livemode: false,
         metadata: %{},
         name: "some-cool-plan",
         object: "plan",
         statement_descriptor: nil,
         trial_period_days: nil
       },
       quantity: 1,
       source: nil,
       start: 1_517_111_396,
       status: "active",
       tax_percent: nil,
       trial_end: nil,
       trial_start: nil
     }}
  end
end
