defmodule TossBounty.UserModelTest do
  use TossBounty.ModelCase, async: true
  alias TossBounty.User

  @valid_attrs %{name: "A User", password: "secret", email: "test@test.com"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end
