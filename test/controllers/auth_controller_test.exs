defmodule TossBounty.AuthControllerTest do
  use TossBounty.ApiCase
  import TossBounty.AuthenticationTestHelpers
  alias TossBounty.User
  alias TossBounty.Repo
  alias TossBounty.SellableRepos
  alias TossBounty.SellableRepos.MockReposGrabber
  alias TossBounty.GitHubRepo

  setup do
    conn = build_conn()
    {:ok, conn: conn}
  end

  @valid_attrs %{
    code: "some-code",
    provider: "github"
  }

  describe "callback" do
    test "creates user if one not found", %{conn: conn} do
      conn = get conn, "/auth/github/callback?code=stuff"
      user_count = Repo.one(from u in User, select: count("*"))
      assert user_count == 1
    end

    test "updates the user's github token if already in db", %{conn: conn} do
      Repo.insert!(%User{email: "test@test.com", github_token: "different-token"})
      conn = get conn, "/auth/github/callback?code=stuff"
      user = Repo.get_by(User, email: "test@test.com")
      assert user.github_token != "different-token"
    end

    test "does not create a new user if already in in db", %{conn: conn} do
      Repo.insert!(%User{email: "test@test.com", github_token: "different-token"})
      conn = get conn, "/auth/github/callback?code=stuff"
      user_count = Repo.one(from u in User, select: count("*"))
      assert user_count == 1
    end

    test "creates github repos in the db", %{conn: conn} do
      MockReposGrabber.clear
      MockReposGrabber.insert_repo(%{ "name": "Barter", "open_issues_count": 3 })
      conn = get conn, "/auth/github/callback?code=stuff"
      repo_count = Repo.one(from r in GitHubRepo, select: count("*"))
      assert repo_count == 1
    end
  end
end