defmodule TossBountyWeb.PlanControllerTest do
  use TossBountyWeb.ApiCase, resource_name: :campaign
  alias TossBounty.GitHub.GithubRepo
  alias TossBounty.Campaigns
  alias TossBounty.Incentive

  setup do
    user = insert_user(email: "user_with_token@email.com")

    {:ok, user: user}
  end

  @create_attrs %{
    amount: 1000.00,
    interval: "month",
    name: "a name",
    currency: "usd"
  }
  @invalid_attrs %{
    amount: nil,
    interval: nil,
    name: nil,
    currency: nil
  }

  defp dasherize_keys(attrs) do
    Enum.map(attrs, fn {k, v} -> {JaSerializer.Formatter.Utils.format_key(k), v} end)
    |> Enum.into(%{})
  end

  defp relationships(reward) do
    %{
      "reward" => %{
        "data" => %{
          "type" => "reward",
          "id" => reward.id
        }
      }
    }
  end

  def create_fixture_github_repo(attrs \\ %{}) do
    user = attrs[:user]

    github_repo_attrs = %{
      name: "a name",
      owner: "an owner",
      bountiful_score: 5,
      image: "an-img-path",
      user_id: user.id
    }

    {:ok, github_repo} =
      %GithubRepo{}
      |> GithubRepo.changeset(github_repo_attrs)
      |> Repo.insert()

    {:ok, user: user, github_repo: github_repo}
  end

  def create_fixture_campaign(attrs \\ %{}) do
    user = attrs[:user]
    github_repo = attrs[:github_repo]

    campaign_attrs = %{
      short_description: "a short description",
      long_description: "a longer description",
      funding_goal: 20000.00,
      funding_end_date: Timex.parse!("Tue, 06 Mar 2013 01:25:19 +0200", "{RFC1123}"),
      user_id: user.id,
      github_repo_id: github_repo.id
    }

    {:ok, campaign} =
      campaign_attrs
      |> Campaigns.create_campaign()

    {:ok, user: user, github_repo: github_repo, campaign: campaign}
  end

  def create_fixture_reward(attrs \\ %{}) do
    user = attrs[:user]
    campaign = attrs[:campaign]
    github_repo = attrs[:github_repo]

    reward_attrs = %{
      description: "some reward 1",
      donation_level: 20.00,
      campaign_id: campaign.id
    }

    {:ok, reward} = Incentive.create_reward(reward_attrs)

    {:ok, user: user, github_repo: github_repo, campaign: campaign, reward: reward}
  end

  describe "create plan" do
    setup [:create_fixture_github_repo, :create_fixture_campaign, :create_fixture_reward]
    @tag :authenticated
    test "renders plan when data is valid", %{conn: conn, reward: reward} do
      attrs =
        @create_attrs
        |> Map.put(:reward_id, reward.id)

      conn =
        post(conn, plan_path(conn, :create), %{
          "meta" => %{},
          "data" => %{
            "type" => "plan",
            "attributes" => dasherize_keys(attrs),
            "relationships" => relationships(reward)
          }
        })

      assert %{"id" => id} = json_response(conn, 201)["data"]
    end

    @tag :authenticated
    test "renders errors when data is invalid", %{conn: conn, reward: reward} do
      conn =
        post(conn, plan_path(conn, :create), %{
          "meta" => %{},
          "data" => %{
            "type" => "plan",
            "attributes" => dasherize_keys(@invalid_attrs),
            "relationships" => relationships(reward)
          }
        })

      assert json_response(conn, 422)["errors"] != %{}
    end
  end
end
