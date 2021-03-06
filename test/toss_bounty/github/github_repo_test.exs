defmodule TossBounty.Github.GithubRepoModelTest do
  use TossBountyWeb.DataCase, async: true
  alias TossBounty.Github.GithubRepo
  alias TossBounty.Accounts.User

  describe "repo changeset" do
    @valid_attrs %{name: "toss_bounty", owner: "trodrigu", bountiful_score: 3, image: "avatar"}
    @invalid_attrs %{user_id: 9999}

    setup do
      user = with {:ok, user} <- Repo.insert!(%User{email: "test@test.com"}), do: user
      {:ok, user: user}
    end

    test "changeset with valid attributes", %{user: user} do
      attrs = Map.put(@valid_attrs, :user_id, user.id)
      changeset = GithubRepo.changeset(%GithubRepo{}, attrs)
      assert changeset.valid?
    end

    test "changeset with invalid attributes" do
      changeset = GithubRepo.changeset(%GithubRepo{}, @invalid_attrs)
      {:error, updated_changeset} = Repo.insert(changeset)
      refute updated_changeset.valid?
    end
  end
end
