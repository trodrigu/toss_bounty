defmodule TossBounty.Policy.Helpers do
  @moduledoc """
  Holds helpers for extracting record relationships and determining roles for
  authorization policies.
  """

  alias TossBounty.{
    Accounts.User,
    Campaigns.Campaign,
    Incentive.Reward,
    Repo
  }

  alias Ecto.Changeset

  @doc """
  Determines if the provided campaign is belongs to the provided user
  """
  def belongs_to?(%Campaign{user_id: user_id}, %User{id: other_user_id}), do: user_id == other_user_id
  def belongs_to?(nil, _), do: false
  def belongs_to?(%Reward{campaign_id: campaign_id} = reward, %User{id: user_id}) do
    preloaded_reward =
      reward
      |> Repo.preload [ :campaign ]

    campaign =
      preloaded_reward.campaign

    preloaded_campaign =
      campaign
      |> Repo.preload [ :user ]

    user_from_campaign = preloaded_campaign.user

    user_id == user_from_campaign.id
  end
end
