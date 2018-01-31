defmodule TossBounty.Policy.Subscription do
  alias TossBounty.{StripeProcessing.Subscription, Accounts.User}
  import TossBounty.Policy, only: [belongs_to?: 2]

  def administer?(%User{} = user, %Subscription{} = subscription) do
    subscription |> belongs_to?(user)
  end
end
