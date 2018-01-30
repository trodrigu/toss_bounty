defmodule TossBounty.Policy.Plan do
  alias TossBounty.{StripeProcessing.Plan, Accounts.User}
  import TossBounty.Policy, only: [belongs_to?: 2]

  def administer?(%User{} = user, %Plan{} = plan) do
    plan |> belongs_to?(user)
  end
end
