defmodule TossBounty.StripeProcessingTest do
  use TossBountyWeb.DataCase

  alias TossBounty.StripeProcessing
  alias TossBounty.StripeProcessing.Charge
  import TossBountyWeb.TestHelpers

  setup do
    maintainer = insert_user(email: "maintainer@test.com")
    contributor = insert_user(email: "contributor@test.com")
    {:ok, maintainer: maintainer, contributor: contributor}
  end

  describe "charges" do
    @valid_attrs %{
      token: "some-token",
      amount: 1000.0,
      successful: true,
      message: "this is a message"
    }
    @invalid_attrs %{
      token: nil,
      amount: nil,
      successful: nil,
      message: nil
    }

    test "create_charge/1 returns the charge with given id", %{
      maintainer: maintainer,
      contributor: contributor
    } do
      attrs =
        @valid_attrs
        |> Map.put(:maintainer_id, maintainer.id)
        |> Map.put(:contributor_id, contributor.id)

      assert {:ok, %Charge{} = charge} = StripeProcessing.create_charge(attrs)
      assert charge.token == "some-token"
    end

    test "create_charge/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = StripeProcessing.create_charge(@invalid_attrs)
    end
  end
end
