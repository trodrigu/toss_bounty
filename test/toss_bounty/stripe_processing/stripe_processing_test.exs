defmodule TossBounty.StripeProcessingTest do
  use TossBountyWeb.DataCase

  alias TossBounty.StripeProcessing
  alias TossBounty.StripeProcessing.Subscription
  alias TossBounty.StripeProcessing.Plan
  alias TossBounty.StripeProcessing.Customer
  alias TossBounty.StripeProcessing.Charge
  alias TossBounty.StripeProcessing.Token
  alias TossBounty.Github.GithubRepo
  alias TossBounty.Campaigns
  alias TossBounty.Incentive
  import TossBountyWeb.TestHelpers

  setup do
    user = insert_user(email: "user_with_token@email.com")

    {:ok, user: user}
  end

  describe "subscriptions" do
    @valid_attrs %{
      uuid: "some-subscription-1"
    }
    @invalid_attrs %{
      uuid: nil
    }

    setup [
      :create_fixture_token,
      :create_fixture_customer,
      :create_fixture_github_repo,
      :create_fixture_campaign,
      :create_fixture_reward,
      :create_fixture_plan
    ]

    test "create_subscription/1 returns the subscription with given id", %{
      plan: plan,
      customer: customer
    } do
      attrs =
        @valid_attrs
        |> Map.put(:plan_id, plan.id)
        |> Map.put(:customer_id, customer.id)

      assert {:ok, %Subscription{} = subscription} = StripeProcessing.create_subscription(attrs)
      assert subscription.uuid == "some-subscription-1"
    end

    test "create_subscription/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = StripeProcessing.create_subscription(@invalid_attrs)
    end

    setup [
      :create_fixture_token,
      :create_fixture_customer,
      :create_fixture_github_repo,
      :create_fixture_campaign,
      :create_fixture_reward,
      :create_fixture_plan,
      :create_fixture_subscription
    ]

    test "get_subscription!/1 returns the subscription with given id", %{
      subscription: subscription
    } do
      assert StripeProcessing.get_subscription!(subscription.id) == subscription
    end

    test "delete_subscription/1 deletes the subscription", %{subscription: subscription} do
      assert {:ok, %Subscription{}} = StripeProcessing.delete_subscription(subscription)

      assert_raise Ecto.NoResultsError, fn ->
        StripeProcessing.get_subscription!(subscription.id)
      end
    end
  end

  describe "plans" do
    @valid_attrs %{
      uuid: "some-plan-1",
      amount: 2000,
      interval: "month",
      name: "the gold plan",
      currency: "usd"
    }
    @invalid_attrs %{
      uuid: nil
    }

    setup [:create_fixture_github_repo, :create_fixture_campaign, :create_fixture_reward]

    test "create_plan/1 returns the plan with given id", %{reward: reward} do
      attrs =
        @valid_attrs
        |> Map.put(:reward_id, reward.id)

      assert {:ok, %Plan{} = plan} = StripeProcessing.create_plan(attrs)
      assert plan.uuid == "some-plan-1"
      assert plan.amount == 2000
      assert plan.interval == "month"
      assert plan.name == "the gold plan"
      assert plan.currency == "usd"
    end

    test "create_plan/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = StripeProcessing.create_plan(@invalid_attrs)
    end

    setup [
      :create_fixture_token,
      :create_fixture_customer,
      :create_fixture_github_repo,
      :create_fixture_campaign,
      :create_fixture_reward,
      :create_fixture_plan
    ]

    test "get_plan!/1 returns the plan with given id", %{plan: plan} do
      assert StripeProcessing.get_plan!(plan.id) == plan
    end

    test "delete_plan/1 deletes the plan", %{plan: plan} do
      assert {:ok, %Plan{}} = StripeProcessing.delete_plan(plan)
      assert_raise Ecto.NoResultsError, fn -> StripeProcessing.get_plan!(plan.id) end
    end
  end

  describe "customers" do
    @valid_attrs %{
      uuid: "some-customer-1"
    }
    @invalid_attrs %{
      uuid: nil
    }

    setup [:create_fixture_token]

    test "create_customer/1 returns the customer with given id", %{
      token: token
    } do
      attrs =
        @valid_attrs
        |> Map.put(:token_id, token.id)

      assert {:ok, %Customer{} = customer} = StripeProcessing.create_customer(attrs)
      assert customer.uuid == "some-customer-1"
    end

    test "create_customer/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = StripeProcessing.create_customer(@invalid_attrs)
    end
  end

  describe "tokens" do
    @valid_attrs %{
      uuid: "some-token-1"
    }
    @invalid_attrs %{
      uuid: nil
    }

    test "create_token/1 returns the token with given id", %{
      user: user
    } do
      attrs =
        @valid_attrs
        |> Map.put(:user_id, user.id)

      assert {:ok, %Token{} = token} = StripeProcessing.create_token(attrs)
      assert token.uuid == "some-token-1"
    end

    test "create_token/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = StripeProcessing.create_token(@invalid_attrs)
    end
  end

  describe "charges" do
    @valid_attrs %{
      amount: 1000.0,
      message: "this is a message"
    }
    @invalid_attrs %{
      amount: nil,
      message: nil
    }

    setup [:create_fixture_token]

    test "create_charge/1 returns the charge with given id", %{
      token: token
    } do
      attrs =
        @valid_attrs
        |> Map.put(:token_id, token.id)

      assert {:ok, %Charge{} = charge} = StripeProcessing.create_charge(attrs)

      preloaded_charge =
        charge
        |> Repo.preload([:token])

      assert preloaded_charge.token.uuid == "some-token-1"
    end

    test "create_charge/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = StripeProcessing.create_charge(@invalid_attrs)
    end
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
    token = attrs[:token]
    customer = attrs[:customer]

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
    token = attrs[:token]
    customer = attrs[:customer]

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
    campaign = attrs[:campaign]
    github_repo = attrs[:github_repo]
    token = attrs[:token]
    customer = attrs[:customer]

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
    reward = attrs[:reward]
    campaign = attrs[:campaign]
    github_repo = attrs[:github_repo]
    token = attrs[:token]
    customer = attrs[:customer]

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
end
