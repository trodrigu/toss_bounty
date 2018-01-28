defmodule TossBounty.StripeProcessingTest do
  use TossBountyWeb.DataCase

  alias TossBounty.StripeProcessing
  alias TossBounty.StripeProcessing.Subscription
  alias TossBounty.StripeProcessing.Plan
  alias TossBounty.StripeProcessing.Customer
  alias TossBounty.StripeProcessing.Charge
  alias TossBounty.StripeProcessing.Token
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

    setup [:create_fixture_token, :create_fixture_customer, :create_fixture_plan]

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

    setup [:create_fixture_token, :create_fixture_customer]

    test "create_plan/1 returns the plan with given id" do
      assert {:ok, %Plan{} = plan} = StripeProcessing.create_plan(@valid_attrs)
      assert plan.uuid == "some-plan-1"
      assert plan.amount == 2000
      assert plan.interval == "month"
      assert plan.name == "the gold plan"
      assert plan.currency == "usd"
    end

    test "create_plan/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = StripeProcessing.create_plan(@invalid_attrs)
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

  def create_fixture_plan(attrs \\ %{}) do
    user = attrs[:user]
    token = attrs[:token]
    customer = attrs[:customer]

    plan_attrs = %{
      uuid: "some-plan-1",
      amount: 2000,
      interval: "month",
      name: "the gold plan",
      currency: "usd"
    }

    {:ok, plan} = StripeProcessing.create_plan(plan_attrs)

    {:ok, user: user, token: token, customer: customer, plan: plan}
  end
end
