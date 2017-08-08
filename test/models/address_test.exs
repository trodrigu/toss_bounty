defmodule TossBounty.AddressTest do
  use TossBounty.ModelCase

  alias TossBounty.Address

  @valid_attrs %{city: "some content", latitude: "120.5", longitude: "120.5", state: "some content", street_address: "some content", street_address_2: "some content", user_id: 42, zip: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Address.changeset(%Address{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Address.changeset(%Address{}, @invalid_attrs)
    refute changeset.valid?
  end
end
