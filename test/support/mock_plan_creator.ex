defmodule TossBounty.StripeProcessing.MockStripePlanCreator do
  @behaviour TossBountyWeb.PlanController.Behaviour

  def create(_attrs) do
    {:ok,
     %Stripe.Plan{
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
     }}
  end
end
