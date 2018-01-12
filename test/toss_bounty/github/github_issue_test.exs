defmodule TossBounty.GitHub.GithubIssueTest do
  use TossBountyWeb.DataCase, async: true
  alias TossBounty.GitHub.GithubIssue
  alias TossBounty.Accounts.User

  describe "issue changeset" do

    @valid_attrs %{title: "some title", body: "some body"}
    @invalid_attrs %{github_repo_id: 9999}

    test "changeset with valid attributes" do
      changeset = GithubIssue.changeset(%GithubIssue{}, @valid_attrs)
      assert changeset.valid?
    end

    test "changeset with invalid attributes" do
      changeset = GithubIssue.changeset(%GithubIssue{}, @invalid_attrs)
      {:error, updated_changeset} = Repo.insert(changeset)
      refute updated_changeset.valid?
    end
  end
end
