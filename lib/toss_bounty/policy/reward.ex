defmodule TossBounty.Policy.Reward do

  alias TossBounty.{Incentive.Reward, Accounts.User}
  import TossBounty.Policy, only: [belongs_to?: 2]

  def administer?(%User{} = user, %Reward{} = reward), do: reward |> belongs_to?(user)
end
