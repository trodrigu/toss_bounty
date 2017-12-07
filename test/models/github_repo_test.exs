defmodule TossBountyWeb.GitHubRepoModelTest do
  use TossBountyWeb.ModelCase, async: true
  alias TossBountyWeb.GitHubRepo
  alias TossBountyWeb.User

  describe "repo changeset" do
    @valid_attrs %{name: "toss_bounty", owner: "trodrigu"}
    @invalid_attrs %{user_id: 9999}

    setup do
      user = with {:ok, user} <- Repo.insert!(%User{email: "test@test.com"}), do: user
      {:ok, user: user}
    end

    test "changeset with valid attributes", %{user: user} do
      attrs = Map.put(@valid_attrs, :user_id, user.id)
      changeset = GitHubRepo.changeset(%GitHubRepo{}, attrs)
      assert changeset.valid?
    end

    test "changeset with invalid attributes" do
      changeset = GitHubRepo.changeset(%GitHubRepo{}, @invalid_attrs)
      {:error, updated_changeset} = Repo.insert(changeset)
      refute updated_changeset.valid?
    end
  end
end
