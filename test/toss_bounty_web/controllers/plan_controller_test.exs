defmodule TossBountyWeb.PlanControllerTest do
  use TossBountyWeb.ApiCase, resource_name: :plan
  alias TossBounty.Github.GithubRepo
  alias TossBounty.Campaigns
  alias TossBounty.Incentive
  alias TossBounty.Incentive.Reward
  alias TossBounty.StripeProcessing
  alias TossBounty.StripeProcessing.Plan
  alias TossBounty.StripeProcessing.Token
  alias TossBounty.StripeProcessing.Customer
  alias TossBounty.StripeProcessing.Subscription
  alias TossBounty.Accounts.User
  alias TossBounty.Campaigns.Campaign

  setup config = %{conn: conn, current_user: current_user} do
    user =
      case current_user do
        %User{} ->
          current_user

        _ ->
          insert_user(email: "some_email@test.com")
      end

    {:ok, user: user}
  end

  @create_attrs %{
    amount: 1000.00,
    interval: "month",
    name: "a name",
    currency: "usd"
  }
  @update_attrs %{
    amount: 1100.00,
    interval: "month",
    name: "another name",
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

  def create_fixture_token(attrs \\ %{}) do
    user = attrs[:user]

    token_attrs = %{
      uuid: "some-token-1",
      user_id: user.id
    }

    {:ok, token} = StripeProcessing.create_token(token_attrs)

    {:ok, user: user, token: token}
  end

  def create_fixture_customer(attrs \\ %{}) do
    user = attrs[:user]
    token = attrs[:token]

    customer_attrs = %{
      uuid: "some-customer-1",
      token_id: token.id
    }

    {:ok, customer} = StripeProcessing.create_customer(customer_attrs)

    {:ok, user: user, token: token, customer: customer}
  end

  def create_fixture_github_repo(relationships \\ %{}, github_repo_attrs \\ %{}) do
    user = relationships[:user]

    updated_github_repo_attrs =
      github_repo_attrs
      |> Enum.into(%{
        name: "a name",
        owner: "an owner",
        bountiful_score: 5,
        image: "an-img-path",
        user_id: user.id
      })

    {:ok, github_repo} =
      %GithubRepo{}
      |> GithubRepo.changeset(updated_github_repo_attrs)
      |> Repo.insert()

    {:ok, user: user, github_repo: github_repo}
  end

  def create_fixture_campaign(relationships \\ %{}, campaign_attrs \\ %{}) do
    user = relationships[:user]
    github_repo = relationships[:github_repo]

    updated_campaign_attrs =
      campaign_attrs
      |> Enum.into(%{
        long_description: "a longer description",
        funding_goal: 20000.00,
        user_id: user.id,
        github_repo_id: github_repo.id
      })

    {:ok, campaign} =
      updated_campaign_attrs
      |> Campaigns.create_campaign()

    {:ok, user: user, github_repo: github_repo, campaign: campaign}
  end

  def create_fixture_reward(relationships \\ %{}, reward_attrs \\ %{}) do
    user = relationships[:user]
    campaign = relationships[:campaign]
    github_repo = relationships[:github_repo]

    updated_reward_attrs =
      reward_attrs
      |> Enum.into(%{
        description: "some reward 1",
        donation_level: 20.00,
        campaign_id: campaign.id
      })

    {:ok, reward} = Incentive.create_reward(updated_reward_attrs)

    {:ok, user: user, github_repo: github_repo, campaign: campaign, reward: reward}
  end

  def create_fixture_plan(relationships \\ %{}, plan_attrs \\ %{}) do
    user = relationships[:user]
    reward = relationships[:reward]
    campaign = relationships[:campaign]
    github_repo = relationships[:github_repo]

    updated_plan_attrs =
      plan_attrs
      |> Enum.into(%{
        uuid: "some-plan-1",
        amount: 2000,
        interval: "month",
        name: "the gold plan",
        currency: "usd",
        reward_id: reward.id
      })

    {:ok, plan} = StripeProcessing.create_plan(updated_plan_attrs)

    {:ok, user: user, github_repo: github_repo, campaign: campaign, reward: reward, plan: plan}
  end

  def create_fixture_subscription(attrs \\ %{}) do
    user = attrs[:user]
    reward = attrs[:reward]
    campaign = attrs[:campaign]
    github_repo = attrs[:github_repo]
    plan = attrs[:plan]
    token = attrs[:token]
    customer = attrs[:customer]

    subscription_attrs = %{
      uuid: "some-subscription-1",
      plan_id: plan.id,
      customer_id: customer.id
    }

    {:ok, subscription} = StripeProcessing.create_subscription(subscription_attrs)

    {:ok,
     user: user,
     token: token,
     customer: customer,
     github_repo: github_repo,
     campaign: campaign,
     reward: reward,
     plan: plan,
     subscription: subscription}
  end

  describe "index plan" do
    setup [
      :create_fixture_github_repo,
      :create_fixture_campaign,
      :create_fixture_reward,
      :create_fixture_plan
    ]

    @tag :authenticated
    test "renders index of plans", %{conn: conn} do
      conn = get(conn, github_issue_path(conn, :index))
      assert conn |> json_response(200)
    end

    @tag :authenticated
    test "renders index of plans filtered by campaign id", %{campaign: campaign} do
      other_repo = Repo.insert!(%GithubRepo{name: "foobar"})

      other_campaign =
        Repo.insert!(%Campaign{
          current_funding: 100.0,
          funding_goal: 100.0,
          github_repo_id: other_repo.id
        })

      other_reward =
        Repo.insert!(%Reward{
          description: "description",
          donation_level: 100.0,
          campaign_id: other_campaign.id
        })

      other_plan =
        Repo.insert!(%Plan{
          uuid: "12jfklsdf",
          amount: 100.0,
          interval: "month",
          name: "some name",
          currency: "usd",
          reward_id: other_reward.id
        })

      user = Repo.one(from(u in User, limit: 1))
      {:ok, jwt, _} = Guardian.encode_and_sign(user)

      conn =
        conn()
        |> put_req_header("authorization", "Bearer #{jwt}")
        |> get(plan_path(conn, :index), %{campaign_id: campaign.id})

      response = json_response(conn, 200)

      plan_from_response =
        response["data"]
        |> Enum.at(0)

      plans_title = plan_from_response["attributes"]["uuid"]
      assert plans_title != "12jfklsdf"
      assert plans_title == "some-plan-1"
      assert Enum.count(response["data"]) == 1
    end

    setup [
      :create_fixture_token,
      :create_fixture_customer,
      :create_fixture_subscription
    ]

    @tag :authenticated
    test "renders index of plans filtered by subscription id", %{subscription: subscription} do
      other_user = insert_user(email: "another_email@test.com")

      other_repo = Repo.insert!(%GithubRepo{name: "foobar"})

      other_campaign =
        Repo.insert!(%Campaign{
          current_funding: 100.0,
          funding_goal: 100.0,
          github_repo_id: other_repo.id
        })

      other_reward =
        Repo.insert!(%Reward{
          description: "description",
          donation_level: 100.0,
          campaign_id: other_campaign.id
        })

      other_plan =
        Repo.insert!(%Plan{
          uuid: "12jfklsdf",
          amount: 100.0,
          interval: "month",
          name: "some name",
          currency: "usd",
          reward_id: other_reward.id
        })

      other_token =
        Repo.insert!(%Token{
          uuid: "jkl342sdf",
          user_id: other_user.id
        })

      other_customer =
        Repo.insert!(%Customer{
          uuid: "23sdfommsd",
          token_id: other_token.id
        })

      other_subcription =
        Repo.insert!(%Subscription{
          uuid: "234sdfasd",
          customer_id: other_customer.id,
          plan_id: other_plan.id
        })

      user = Repo.one(from(u in User, limit: 1))
      {:ok, jwt, _} = Guardian.encode_and_sign(user)

      conn =
        conn()
        |> put_req_header("authorization", "Bearer #{jwt}")
        |> get(plan_path(conn, :index), %{subscriber_id: user.id})

      response = json_response(conn, 200)

      plans_from_response = response["data"]

      plans_count =
        plans_from_response
        |> Enum.count()

      assert plans_count == 1

      plan_response =
        plans_from_response
        |> Enum.at(0)

      assert plan_response["attributes"]["uuid"] != "12jfklsdf"
    end
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

  describe "update plan" do
    setup [
      :create_fixture_github_repo,
      :create_fixture_campaign,
      :create_fixture_reward,
      :create_fixture_plan
    ]

    @tag :authenticated
    test "renders plan when data is valid", %{conn: conn, plan: plan} do
      conn =
        put(conn, plan_path(conn, :update, plan), %{
          "meta" => %{},
          "data" => %{
            "type" => "plan",
            "attributes" => dasherize_keys(@update_attrs)
          }
        })

      data = json_response(conn, 200)["data"]
      assert data["id"] == "#{plan.id}"
      assert data["type"] == "plan"
      assert data["attributes"]["interval"] == "month"
      assert data["attributes"]["name"] == "another name"
      assert data["attributes"]["currency"] == "usd"
    end

    @tag :authenticated
    test "renders errors when data is invalid", %{conn: conn, plan: plan} do
      conn =
        put(conn, plan_path(conn, :update, plan), %{
          "meta" => %{},
          "data" => %{
            "type" => "plan",
            "attributes" => dasherize_keys(@invalid_attrs)
          }
        })

      assert json_response(conn, 422)["errors"] != %{}
    end

    @tag :authenticated
    test "renders errors when not authorized", %{conn: conn, plan: plan} do
      another_user = insert_user(email: "test2@test.com")

      {:ok, user: _user, github_repo: github_repo} =
        create_fixture_github_repo(%{user: another_user})

      {:ok, user: _user, github_repo: _github_repo, campaign: campaign} =
        create_fixture_campaign(%{github_repo: github_repo, user: another_user})

      {:ok, user: _user, github_repo: _github_repo, campaign: _campaign, reward: reward} =
        create_fixture_reward(%{campaign: campaign})

      {:ok,
       user: _user,
       github_repo: _github_repo,
       campaign: _campaign,
       reward: _reward,
       plan: another_plan_from_different_user} = create_fixture_plan(%{reward: reward})

      conn =
        put(conn, plan_path(conn, :update, another_plan_from_different_user), %{
          "meta" => %{},
          "data" => %{
            "type" => "plan",
            "attributes" => dasherize_keys(@update_attrs)
          }
        })

      assert json_response(conn, 403)["errors"] != %{}
    end
  end

  describe "delete plan" do
    setup [
      :create_fixture_github_repo,
      :create_fixture_campaign,
      :create_fixture_reward,
      :create_fixture_plan,
      :create_fixture_token,
      :create_fixture_customer,
      :create_fixture_subscription
    ]

    @tag :authenticated
    test "deletes chosen plan", %{conn: conn, plan: plan} do
      conn = delete(conn, plan_path(conn, :delete, plan))
      assert response(conn, 204)
    end

    @tag :authenticated
    test "deletes dependent subscriptions", %{conn: conn, plan: plan} do
      conn = delete(conn, plan_path(conn, :delete, plan))

      subscription_count =
        Subscription
        |> Repo.all()
        |> Enum.count()

      assert subscription_count == 0
    end

    @tag :authenticated
    test "renders errors when not authorized", %{conn: conn, plan: plan} do
      another_user = insert_user(email: "test2@test.com")

      {:ok, jwt, _} = Guardian.encode_and_sign(another_user)

      delete_conn =
        conn()
        |> put_req_header("authorization", "Bearer #{jwt}")

      conn = delete(delete_conn, plan_path(conn, :delete, plan))
      assert json_response(conn, 403)["errors"] != %{}
    end

    test "renders 401 when not authenticated", %{conn: conn, plan: plan} do
      conn = delete(conn, plan_path(conn, :delete, plan))
      assert conn |> json_response(401)
    end

    @tag :authenticated
    test "renders errors when stripe service returns none found", %{conn: conn, plan: plan} do
      conn_with_errors =
        conn
        |> add_stripe_client_none_found

      conn = delete(conn_with_errors, plan_path(conn_with_errors, :delete, plan))
      assert response(conn, 404)
    end

    defp add_stripe_client_none_found(conn) do
      conn
      |> Plug.Conn.assign(:errors, :none_found)
    end
  end
end
