defmodule TossBounty.StripeProcessingTest do
  use TossBountyWeb.DataCase

  alias TossBounty.StripeProcessing
  alias TossBounty.StripeProcessing.Customer
  alias TossBounty.StripeProcessing.Charge
  alias TossBounty.StripeProcessing.Token
  import TossBountyWeb.TestHelpers

  setup do
    user = insert_user(email: "user_with_token@email.com")

    {:ok, user: user}
  end

  describe "customers" do
    @valid_attrs %{
      uuid: "some-customer-1"
    }
    @invalid_attrs %{
      uuid: nil
    }

    test "create_customer/1 returns the customer with given id", %{
      user: user
    } do
      attrs =
        @valid_attrs
        |> Map.put(:user_id, user.id)

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

    {:ok, token: token}
  end
end
