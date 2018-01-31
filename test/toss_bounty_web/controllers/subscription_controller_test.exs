defmodule TossBountyWeb.SubscriptionControllerTest do
  use TossBountyWeb.ApiCase, resource_name: :subscription
  alias TossBounty.GitHub.GithubRepo
  alias TossBounty.Campaigns
  alias TossBounty.Incentive
  alias TossBounty.StripeProcessing
  alias TossBounty.Accounts.User

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

  defp relationships(customer, plan) do
    %{
      "customer" => %{
        "data" => %{
          "type" => "customer",
          "id" => customer.id
        }
      },
      "plan" => %{
        "data" => %{
          "type" => "plan",
          "id" => plan.id
        }
      }
    }
  end

  defp dasherize_keys(attrs) do
    Enum.map(attrs, fn {k, v} -> {JaSerializer.Formatter.Utils.format_key(k), v} end)
    |> Enum.into(%{})
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

  def create_fixture_github_repo(attrs \\ %{}) do
    user = attrs[:user]
    customer = attrs[:customer]
    token = attrs[:token]

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

    {:ok, user: user, token: token, customer: customer, github_repo: github_repo}
  end

  def create_fixture_campaign(attrs \\ %{}) do
    user = attrs[:user]
    github_repo = attrs[:github_repo]
    customer = attrs[:customer]
    token = attrs[:token]

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

    {:ok,
     user: user, token: token, customer: customer, github_repo: github_repo, campaign: campaign}
  end

  def create_fixture_reward(attrs \\ %{}) do
    user = attrs[:user]
    customer = attrs[:customer]
    token = attrs[:token]
    campaign = attrs[:campaign]
    github_repo = attrs[:github_repo]

    reward_attrs = %{
      description: "some reward 1",
      donation_level: 20.00,
      campaign_id: campaign.id
    }

    {:ok, reward} = Incentive.create_reward(reward_attrs)

    {:ok,
     user: user,
     token: token,
     customer: customer,
     github_repo: github_repo,
     campaign: campaign,
     reward: reward}
  end

  def create_fixture_plan(attrs \\ %{}) do
    user = attrs[:user]
    customer = attrs[:customer]
    token = attrs[:token]
    reward = attrs[:reward]
    campaign = attrs[:campaign]
    github_repo = attrs[:github_repo]

    plan_attrs = %{
      uuid: "some-plan-1",
      amount: 2000,
      interval: "month",
      name: "the gold plan",
      currency: "usd",
      reward_id: reward.id
    }

    {:ok, plan} = StripeProcessing.create_plan(plan_attrs)

    {:ok,
     user: user,
     token: token,
     customer: customer,
     github_repo: github_repo,
     campaign: campaign,
     reward: reward,
     plan: plan}
  end

  def create_fixture_subscription(attrs \\ %{}) do
    user = attrs[:user]
    customer = attrs[:customer]
    token = attrs[:token]
    reward = attrs[:reward]
    campaign = attrs[:campaign]
    github_repo = attrs[:github_repo]
    plan = attrs[:plan]

    subscription_attrs = %{
      uuid: "some-subscription-1",
      customer_id: customer.id,
      plan_id: plan.id
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

  describe "create subscription" do
    setup [
      :create_fixture_token,
      :create_fixture_customer,
      :create_fixture_github_repo,
      :create_fixture_campaign,
      :create_fixture_reward,
      :create_fixture_plan
    ]

    @tag :authenticated
    test "renders customer when data is valid", %{conn: conn, customer: customer, plan: plan} do
      conn =
        post(conn, subscription_path(conn, :create), %{
          "meta" => %{},
          "data" => %{
            "type" => "subscription",
            "relationships" => relationships(customer, plan)
          }
        })

      assert %{"id" => id} = json_response(conn, 201)["data"]
    end

    @tag :authenticated
    test "renders errors when data is invalid", %{conn: conn} do
      conn =
        post(conn, customer_path(conn, :create), %{
          "meta" => %{},
          "data" => %{
            "type" => "customer"
          }
        })

      assert json_response(conn, 422)["errors"] != %{}
    end

    test "renders 401 when not authenticated", %{conn: conn, customer: customer, plan: plan} do
      conn =
        post(conn, customer_path(conn, :create), %{
          "meta" => %{},
          "data" => %{
            "type" => "customer",
            "relationships" => relationships(customer, plan)
          }
        })

      assert json_response(conn, 401)["errors"] != %{}
    end
  end

  describe "delete subscription" do
    setup [
      :create_fixture_token,
      :create_fixture_customer,
      :create_fixture_github_repo,
      :create_fixture_campaign,
      :create_fixture_reward,
      :create_fixture_plan,
      :create_fixture_subscription
    ]

    @tag :authenticated
    test "deletes chosen subscription", %{conn: conn, subscription: subscription} do
      conn = delete(conn, subscription_path(conn, :delete, subscription))
      assert response(conn, 204)
    end

    @tag :authenticated
    test "renders errors when not authorized", %{conn: conn, subscription: subscription} do
      another_user = insert_user(email: "test2@test.com")

      {:ok, jwt, _} = Guardian.encode_and_sign(another_user)

      delete_conn =
        conn()
        |> put_req_header("authorization", "Bearer #{jwt}")

      conn = delete(delete_conn, subscription_path(conn, :delete, subscription))
      assert json_response(conn, 403)["errors"] != %{}
    end

    test "renders 401 when not authenticated", %{conn: conn, subscription: subscription} do
      conn = delete(conn, subscription_path(conn, :delete, subscription))
      assert conn |> json_response(401)
    end

    @tag :authenticated
    test "renders errors when stripe service returns none found", %{
      conn: conn,
      subscription: subscription
    } do
      conn_with_errors =
        conn
        |> add_stripe_client_none_found

      conn = delete(conn_with_errors, subscription_path(conn_with_errors, :delete, subscription))
      assert response(conn, 404)
    end

    defp add_stripe_client_none_found(conn) do
      conn
      |> Plug.Conn.assign(:errors, :none_found)
    end
  end
end
