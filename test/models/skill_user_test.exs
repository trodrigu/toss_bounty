defmodule TossBounty.SkillUserTest do
  use TossBounty.ModelCase

  alias TossBounty.SkillUser

  @valid_attrs %{details: "some content", skill_id: 42, user_id: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = SkillUser.changeset(%SkillUser{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = SkillUser.changeset(%SkillUser{}, @invalid_attrs)
    refute changeset.valid?
  end
end
