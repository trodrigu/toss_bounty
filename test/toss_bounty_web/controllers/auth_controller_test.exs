defmodule TossBountyWeb.AuthControllerTest do
  use TossBountyWeb.ApiCase
  import TossBountyWeb.AuthenticationTestHelpers
  alias TossBounty.User
  alias TossBounty.Repo
  alias TossBountyWeb.SellableRepos
  alias TossBountyWeb.SellableIssues
  alias TossBountyWeb.SellableRepos.MockReposGrabber
  alias TossBountyWeb.SellableIssues.MockIssuesGrabber
  alias TossBounty.GitHubRepo
  alias TossBountyWeb.GitHubIssue

  setup do
    conn = build_conn()
    {:ok, conn: conn}
  end

  @valid_attrs %{
    code: "some-code",
    provider: "github"
  }

  describe "callback" do
    test "returns the email, auth token and id", %{conn: conn} do
      conn = get conn, "/auth/github/callback?code=stuff"
      assert redirected_to(conn) =~ "/save-session"
      assert redirected_to(conn) =~ "email"
      assert redirected_to(conn) =~ "token"
      assert redirected_to(conn) =~ "user_id"
    end

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
      MockReposGrabber.insert_repo(%{ "name" => "Barter", "open_issues_count" => 3, "owner" => %{ "login" => "smcfarlane" } })
      conn = get conn, "/auth/github/callback?code=stuff"
      repo_count = Repo.one(from r in GitHubRepo, select: count("*"))
      assert repo_count == 1
    end

    test "associates the github repo with a user", %{conn: conn} do
      MockReposGrabber.clear
      MockReposGrabber.insert_repo(%{ "name" => "Barter", "open_issues_count" => 3, "owner" => %{ "login" => "smcfarlane" } })
      conn = get conn, "/auth/github/callback?code=stuff"
      repo = Repo.one(GitHubRepo)
      user = Repo.one(User)
      preloaded_repo = Repo.preload(repo, [ :user ])
      assert preloaded_repo.user == user
    end

    test "creates github issues in the db", %{conn: conn} do
      MockReposGrabber.clear
      SellableIssues.MockIssuesGrabber.clear
      issues =
        [%{"assignee" => nil, "assignees" => [], "author_association" => "NONE",
            "body" => "Hi, I noticed these `<video>` attributes are missing from the `Attributes` module:\r\n- `crossorigin`\r\n- `mediagroup`\r\n- `muted`\r\nhttps://www.w3.org/TR/html5/embedded-content-0.html#the-video-element\r\n\r\nWould you be interested in a PR?\r\n",
            "closed_at" => nil, "comments" => 1,
            "comments_url" => "https://api.github.com/repos/elm-lang/html/issues/154/comments",
            "created_at" => "2017-11-21T15:01:34Z",
            "events_url" => "https://api.github.com/repos/elm-lang/html/issues/154/events",
            "html_url" => "https://github.com/elm-lang/html/issues/154",
            "id" => 275743372, "labels" => [],
            "labels_url" => "https://api.github.com/repos/elm-lang/html/issues/154/labels{/name}",
            "locked" => false, "milestone" => nil, "number" => 154,
            "reactions" => %{"+1" => 3, "-1" => 0, "confused" => 0, "heart" => 0,
              "hooray" => 0, "laugh" => 0, "total_count" => 3,
              "url" => "https://api.github.com/repos/elm-lang/html/issues/154/reactions"},
            "repository_url" => "https://api.github.com/repos/elm-lang/html",
            "state" => "open", "title" => "video attributes missing",
            "updated_at" => "2017-11-21T15:01:34Z",
            "url" => "https://api.github.com/repos/elm-lang/html/issues/154",
            "user" => %{"avatar_url" => "https://avatars2.githubusercontent.com/u/78849?v=4",
              "events_url" => "https://api.github.com/users/kwijibo/events{/privacy}",
              "followers_url" => "https://api.github.com/users/kwijibo/followers",
              "following_url" => "https://api.github.com/users/kwijibo/following{/other_user}",
              "gists_url" => "https://api.github.com/users/kwijibo/gists{/gist_id}",
              "gravatar_id" => "", "html_url" => "https://github.com/kwijibo",
              "id" => 78849, "login" => "kwijibo",
              "organizations_url" => "https://api.github.com/users/kwijibo/orgs",
              "received_events_url" => "https://api.github.com/users/kwijibo/received_events",
              "repos_url" => "https://api.github.com/users/kwijibo/repos",
              "site_admin" => false,
              "starred_url" => "https://api.github.com/users/kwijibo/starred{/owner}{/repo}",
              "subscriptions_url" => "https://api.github.com/users/kwijibo/subscriptions",
              "type" => "User", "url" => "https://api.github.com/users/kwijibo"}}]
      SellableIssues.MockIssuesGrabber.insert_issues issues
      MockReposGrabber.insert_repo(%{ "name" => "Barter", "open_issues_count" => 3, "owner" => %{ "login" => "smcfarlane" } })
      conn = get conn, "/auth/github/callback?code=stuff"
      issue_count = Repo.one(from r in GitHubIssue, select: count("*"))
      assert issue_count == 1
    end
  end
end
