defmodule TossBounty.GitHubRepoModelTest do
  use TossBounty.ModelCase, async: true
  alias TossBounty.GitHubRepo

  describe "repo changeset" do

    @valid_attrs %{name: "toss_bounty"}
    @invalid_attrs %{}
    test "changeset with valid attributes" do
      changeset = GitHubRepo.changeset(%GitHubRepo{}, @valid_attrs)
      assert changeset.valid?
    end

    test "changeset with invalid attributes" do
      changeset = GitHubRepo.changeset(%GitHubRepo{}, @valid_attrs)
      assert changeset.valid?
    end
  end
end
