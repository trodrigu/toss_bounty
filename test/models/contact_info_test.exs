defmodule TossBounty.ContactInfoTest do
  use TossBounty.ModelCase

  alias TossBounty.ContactInfo

  @valid_attrs %{full_name: "some content", phone: "some content", website: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = ContactInfo.changeset(%ContactInfo{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = ContactInfo.changeset(%ContactInfo{}, @invalid_attrs)
    refute changeset.valid?
  end
end
