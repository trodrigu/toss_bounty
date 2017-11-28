defmodule TossBounty.GithubRepoModelTest do
  use TossBounty.ModelCase, async: true
  alias TossBounty.GithubRepo

  describe "repo changeset" do

    @valid_attrs %{name: "toss_bounty"}
    @invalid_attrs %{}
    test "changeset with valid attributes" do
      changeset = GithubRepo.changeset(%GithubRepo{}, @valid_attrs)
      assert changeset.valid?
    end

    test "changeset with invalid attributes" do
      changeset = GithubRepo.changeset(%GithubRepo{}, @valid_attrs)
      assert changeset.valid?
    end
  end
end
