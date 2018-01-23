defmodule TossBounty.StripeProcessingTest do
  use TossBountyWeb.DataCase

  alias TossBounty.StripeProcessing
  alias TossBounty.StripeProcessing.Charge
  import TossBountyWeb.TestHelpers

  setup do
    user = insert_user(email: "charged@test.com")
    {:ok, user: user}
  end

  describe "charges" do
    @valid_attrs %{
      token: "some-token"
    }
    @invalid_attrs %{
      token: nil
    }

    test "create_charge/1 returns the charge with given id", %{user: user} do
      attrs = Map.put(@valid_attrs, :user_id, user.id)
      assert {:ok, %Charge{} = charge} = StripeProcessing.create_charge(attrs)
      assert charge.token == "some-token"
    end

    test "create_charge/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = StripeProcessing.create_charge(@invalid_attrs)
    end
  end
end
