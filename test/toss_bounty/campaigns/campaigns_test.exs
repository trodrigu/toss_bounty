defmodule TossBounty.CampaignsTest do
  use TossBountyWeb.DataCase

  alias TossBounty.Campaigns
  alias TossBounty.Accounts.User
  alias TossBounty.GitHub.GitHubRepo

  setup do
    user = with {:ok, user} <- Repo.insert!(%User{email: "test@test.com"}), do: user
    github_repo = with {:ok, github_repo} <- Repo.insert!(%GitHubRepo{name: "elm-lang", owner: "trodrigu", bountiful_score: 5, user_id: user.id}), do: github_repo
    {:ok, user: user, github_repo: github_repo}
  end

  describe "campaigns" do
    alias TossBounty.Campaigns.Campaign

    @valid_attrs %{
      current_funding: 120.5,
      funding_end_date: Timex.parse!("Tue, 06 Mar 2013 01:25:19 +0200", "{RFC1123}"),
      funding_goal: 120.5,
      long_description: "some long_description",
      short_description: "some short_description",
    }
    @update_attrs %{
      current_funding: 456.7,
      funding_end_date: Timex.parse!("Tue, 06 Mar 2013 01:25:19 +0200", "{RFC1123}"),
      funding_goal: 456.7,
      long_description: "some updated long_description",
      short_description: "some updated short_description",
    }
    @invalid_attrs %{
      current_funding: nil,
      funding_end_date: nil,
      funding_goal: nil,
      long_description: nil,
      short_description: nil,
    }

    def campaign_fixture(attrs \\ %{}) do
      user = attrs[:user]
      github_repo = attrs[:github_repo]
      attrs_with_user_id = Map.put(@valid_attrs, :user_id, user.id)
      attrs_with_github_repo = Map.put(@valid_attrs, :github_repo_id, github_repo.id)
      {:ok, campaign} =
        attrs_with_user_id
        |> Enum.into(attrs_with_github_repo)
        |> Enum.into(@valid_attrs)
        |> Campaigns.create_campaign()

      campaign
    end

    test "list_campaigns/0 returns all campaigns", %{user: user, github_repo: github_repo} do
      campaign = campaign_fixture(%{user: user, github_repo: github_repo})
      assert Campaigns.list_campaigns() == [campaign]
    end

    test "get_campaign!/1 returns the campaign with given id", %{user: user, github_repo: github_repo} do
      campaign = campaign_fixture(%{user: user, github_repo: github_repo})
      assert Campaigns.get_campaign!(campaign.id) == campaign
    end

    test "create_campaign/1 with valid data creates a campaign", %{user: user} do
      attrs = Map.put(@valid_attrs, :user_id, user.id)
      assert {:ok, %Campaign{} = campaign} = Campaigns.create_campaign(attrs)
      assert campaign.current_funding == 120.5
      assert campaign.funding_end_date == Timex.parse!("Tue, 06 Mar 2013 01:25:19 +0200", "{RFC1123}")
      assert campaign.funding_goal == 120.5
      assert campaign.long_description == "some long_description"
      assert campaign.short_description == "some short_description"
    end

    test "create_campaign/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Campaigns.create_campaign(@invalid_attrs)
    end

    test "update_campaign/2 with valid data updates the campaign", %{user: user, github_repo: github_repo} do
      campaign = campaign_fixture(%{user: user, github_repo: github_repo})
      assert {:ok, campaign} = Campaigns.update_campaign(campaign, @update_attrs)
      assert %Campaign{} = campaign
      assert campaign.current_funding == 456.7
      assert campaign.funding_end_date == Timex.parse!("Tue, 06 Mar 2013 01:25:19 +0200", "{RFC1123}")
      assert campaign.funding_goal == 456.7
      assert campaign.long_description == "some updated long_description"
      assert campaign.short_description == "some updated short_description"
    end

    test "update_campaign/2 with invalid data returns error changeset", %{user: user, github_repo: github_repo} do
      campaign = campaign_fixture(%{user: user, github_repo: github_repo})
      assert {:error, %Ecto.Changeset{}} = Campaigns.update_campaign(campaign, @invalid_attrs)
      assert campaign == Campaigns.get_campaign!(campaign.id)
    end

    test "delete_campaign/1 deletes the campaign", %{user: user, github_repo: github_repo} do
      campaign = campaign_fixture(%{user: user, github_repo: github_repo})
      assert {:ok, %Campaign{}} = Campaigns.delete_campaign(campaign)
      assert_raise Ecto.NoResultsError, fn -> Campaigns.get_campaign!(campaign.id) end
    end

    test "change_campaign/1 returns a campaign changeset", %{user: user, github_repo: github_repo}  do
      campaign = campaign_fixture(%{user: user, github_repo: github_repo})
      assert %Ecto.Changeset{} = Campaigns.change_campaign(campaign)
    end
  end
end
