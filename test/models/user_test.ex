defmodule TossBounty.UserModelTest do
  use TossBounty.ModelCase, async: true
  alias TossBounty.User

  @valid_attrs %{name: "A User", username: "eva", password: "secret", email: "test@test.com"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "changeset does not accept long usernames" do
    attrs = Map.put(@valid_attrs, :username, String.duplicate("a", 30))
    assert {:username, "should be at most 20 character(s)"} in errors_on(%User{}, attrs)
  end

end
