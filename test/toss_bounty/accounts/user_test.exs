defmodule TossBounty.UserModelTest do
  use TossBountyWeb.DataCase, async: true
  alias TossBounty.User

  describe "github registration changeset" do
    @valid_attrs %{github_token: "323jklsdfjklasdf", email: "test@test.com"}
    @invalid_attrs %{}

    test "changeset with valid attributes" do
      changeset = User.github_registration_changeset(%User{}, @valid_attrs)
      assert changeset.valid?
    end

    test "changeset with invalid attributes" do
      changeset = User.github_registration_changeset(%User{}, @invalid_attrs)
      refute changeset.valid?
    end
  end

  describe "user changeset" do
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

  describe "user registration changeset" do

    test "invalid with duplicate email" do
      Repo.insert! %User{email: "test@test.com"}
      changeset = User.registration_changeset(%User{}, %{ name: "A User", password: "secret", password_confirmation: "secret", email: "test@test.com" })
      {:error, updated_changeset} = Repo.insert(changeset)
      refute updated_changeset.valid?
    end
  end
end
