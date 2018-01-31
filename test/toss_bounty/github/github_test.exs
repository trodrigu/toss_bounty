defmodule TossBounty.GithubTest do
  use TossBountyWeb.DataCase

  alias TossBounty.Github
  alias TossBounty.Github.GithubRepo
  alias TossBounty.Accounts.User

  setup do
    user = Repo.insert!(%User{email: "test@test.com"})

    {:ok, user: user}
  end

  def create_fixture_github_repo(attrs \\ %{}) do
    user = attrs[:user]

    github_repo_attrs = %{
      name: "a name",
      owner: "an owner",
      bountiful_score: 5,
      image: "an-img-path",
      user_id: user.id
    }

    {:ok, github_repo} =
      %GithubRepo{}
      |> GithubRepo.changeset(github_repo_attrs)
      |> Repo.insert()

    {:ok, user: user, github_repo: github_repo}
  end

  describe "github_repos" do
    setup [:create_fixture_github_repo]

    test "list_github_repos/0 returns all github repos", %{user: user, github_repo: github_repo} do
      assert Github.list_github_repos() == [github_repo]
    end

    test "list_github_repos/1 returns returns all github repos sorted by user id", %{
      user: user,
      github_repo: github_repo
    } do
      another_user = Repo.insert!(%User{email: "another@email.com"})

      another_github_repo_attrs = %{
        name: "a name",
        owner: "an owner",
        bountiful_score: 5,
        image: "an-img-path",
        user_id: another_user.id
      }

      {:ok, another_github_repo} =
        %GithubRepo{}
        |> GithubRepo.changeset(another_github_repo_attrs)
        |> Repo.insert()

      assert Github.list_github_repos(%{"user_id" => user.id}) == [github_repo]
    end

    test "get_github_repo!/1 returns the github_repo with given id", %{
      user: user,
      github_repo: github_repo
    } do
      assert Github.get_github_repo!(github_repo.id) == github_repo
    end
  end
end
