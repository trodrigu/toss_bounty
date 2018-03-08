defmodule TossBounty.Policy.CampaignTest do
  use TossBounty.PolicyCase

  import TossBounty.Policy.Campaign, only: [administer?: 2]

  alias TossBounty.Campaigns.Campaign
  alias TossBounty.Campaigns
  alias TossBounty.Github.GithubRepo
  alias TossBounty.Accounts.User
  alias TossBounty.Repo

  @campaign_attrs %{
    current_funding: 120.5,
    funding_end_date: Timex.parse!("Tue, 06 Mar 2013 01:25:19 +0200", "{RFC1123}"),
    funding_goal: 120.5,
    long_description: "some long_description"
  }

  describe "administer?" do
    test "returns true when campaign belongs to a user" do
      user = Repo.insert!(%User{name: "foobar"})
      github_repo = Repo.insert!(%GithubRepo{user_id: user.id})
      attrs_with_user = Map.put(@campaign_attrs, :user_id, user.id)
      attrs = Map.put(attrs_with_user, :github_repo_id, github_repo.id)
      {:ok, campaign} = Campaigns.create_campaign(attrs)

      assert administer?(user, campaign)
    end

    test "returns false when campaign belongs to a user" do
      user = Repo.insert!(%User{name: "foobar"})
      another_user = Repo.insert!(%User{name: "another foobar"})
      github_repo = Repo.insert!(%GithubRepo{}, user_id: user.id)
      attrs_with_user = Map.put(@campaign_attrs, :user_id, another_user.id)
      attrs = Map.put(attrs_with_user, :github_repo_id, github_repo.id)

      {:ok, campaign} = Campaigns.create_campaign(attrs)

      refute administer?(user, campaign)
    end
  end
end
