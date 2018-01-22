defmodule TossBounty.Policy do
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
  Determines if a user can perform actions on a given resource.

  The resource is a record.
  """
  def authorize(%User{} = user, action, struct, %{} = params \\ %{}) do
    case user |> can?(action, struct, params) do
      true -> {:ok, :authorized}
      false -> {:error, :not_authorized}
    end
  end

  @doc """
  Determines if the provided campaign or reward is belongs to the provided user
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

  # Campaign
  defp can?(%User{} = current_user, :administer, %Campaign{} = campaign, %{}) do
    TossBounty.Policy.Campaign.administer?(current_user, campaign)
  end

  # Reward
  defp can?(%User{} = current_user, :administer, %Reward{} = reward, %{}) do
    TossBounty.Policy.Reward.administer?(current_user, reward)
  end
end
