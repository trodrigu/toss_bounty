defmodule TossBounty.Policy.Campaign do

  alias TossBounty.{Campaigns.Campaign, Accounts.User}
  import TossBounty.Policy.Helpers, only: [belongs_to?: 2]

  def administer?(%User{} = user, %Campaign{} = campaign), do: campaign |> belongs_to?(user)
end
