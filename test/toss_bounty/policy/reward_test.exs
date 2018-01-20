defmodule TossBounty.Policy.RewardTest do
  use TossBounty.PolicyCase

  import TossBounty.Policy.Reward, only: [administer?: 2]

  alias TossBounty.Incentive.Reward
  alias TossBounty.Incentive
  alias TossBounty.GitHub.GithubRepo
  alias TossBounty.Accounts.User
  alias TossBounty.Repo
  alias TossBounty.Campaigns

  @reward_attrs %{
    description: "some description",
    donation_level: 120.5,
  }

  @campaign_attrs %{
    current_funding: 120.5,
    funding_end_date: Timex.parse!("Tue, 06 Mar 2013 01:25:19 +0200", "{RFC1123}"),
    funding_goal: 120.5,
    long_description: "some long_description",
    short_description: "some short_description",
  }

  setup do
    user = Repo.insert!(%User{email: "test@test.com"})
    github_repo = Repo.insert!(%GithubRepo{ user_id: user.id })
    attrs_with_user = Map.put(@campaign_attrs, :user_id, user.id)
    attrs = Map.put(attrs_with_user, :github_repo_id, github_repo.id)
    {:ok, campaign} =
      Campaigns.create_campaign(attrs)
    {:ok, user: user, campaign: campaign}
  end

  describe "administer?" do
    test "returns true when reward belongs to a user", %{user: user, campaign: campaign} do
      attrs = Map.put(@reward_attrs, :campaign_id, campaign.id)

      {:ok, reward} =
        Incentive.create_reward(attrs)

      assert administer?(user, reward)
    end

    test "returns false when reward belongs to a user", %{user: user, campaign: campaign} do
      attrs = Map.put(@reward_attrs, :campaign_id, campaign.id)

      {:ok, reward} =
        Incentive.create_reward(attrs)

      another_user = Repo.insert!(%User{email: "another_test@test.com"})

      refute administer?(another_user, reward)
    end
  end
end
