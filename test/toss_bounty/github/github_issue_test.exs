defmodule TossBounty.GitHubIssueTest do
  use TossBountyWeb.DataCase, async: true
  alias TossBounty.GitHubIssue
  alias TossBounty.Accounts.User

  describe "issue changeset" do

    @valid_attrs %{title: "some title", body: "some body"}
    @invalid_attrs %{github_repo_id: 9999}

    test "changeset with valid attributes" do
      changeset = GitHubIssue.changeset(%GitHubIssue{}, @valid_attrs)
      assert changeset.valid?
    end

    test "changeset with invalid attributes" do
      changeset = GitHubIssue.changeset(%GitHubIssue{}, @invalid_attrs)
      {:error, updated_changeset} = Repo.insert(changeset)
      refute updated_changeset.valid?
    end
  end
end
