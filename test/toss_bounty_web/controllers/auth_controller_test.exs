defmodule TossBountyWeb.AuthControllerTest do
  use TossBountyWeb.ApiCase
  use Bamboo.Test
  import TossBountyWeb.AuthenticationTestHelpers
  alias TossBounty.Accounts.User
  alias TossBounty.Repo
  alias TossBounty.Github.SellableRepos
  alias TossBounty.Github.SellableIssues
  alias TossBounty.Github.SellableRepos.MockReposGrabber
  alias TossBounty.Github.SellableIssues.MockIssuesGrabber
  alias TossBounty.Github.GithubRepo
  alias TossBounty.Github.GithubIssue
  alias TossBountyWeb.Email

  setup do
    conn = build_conn()
    {:ok, conn: conn}
  end

  describe "callback" do
    @valid_attrs %{
      code: "some-code",
      provider: "github"
    }

    test "when github returns the email, auth token and id", %{conn: conn} do
      conn = get(conn, "/auth/github/callback?code=stuff")
      assert redirected_to(conn) =~ "/save-session"
      assert redirected_to(conn) =~ "email"
      assert redirected_to(conn) =~ "token"
      assert redirected_to(conn) =~ "user_id"
    end

    test "when github returns the email we send out a welcome email", %{conn: conn} do
      conn = get(conn, "/auth/github/callback?code=stuff")
      user = Repo.one(from(u in User))
      assert_delivered_email(TossBountyWeb.Email.welcome_email(user))
    end

    test "when github returns and already received the email", %{conn: conn} do
      insert_user(email: "test@test.com")
      conn = get(conn, "/auth/github/callback?code=stuff")
      user = Repo.one(from(u in User))
      refute_delivered_email(TossBountyWeb.Email.welcome_email(user))
    end

    test "when github creates user if one not found", %{conn: conn} do
      conn = get(conn, "/auth/github/callback?code=stuff")
      user_count = Repo.one(from(u in User, select: count("*")))
      assert user_count == 1
    end

    test "when github returns the email, sends welcome email", %{conn: conn} do
      conn = get(conn, "/auth/github/callback?code=stuff")

      user =
        User
        |> Ecto.Query.first()
        |> Repo.one()

      assert_delivered_email(TossBountyWeb.Email.welcome_email(user))
    end

    test "when github updates the user's github token if already in db", %{conn: conn} do
      Repo.insert!(%User{email: "test@test.com", github_token: "different-token"})
      conn = get(conn, "/auth/github/callback?code=stuff")
      user = Repo.get_by(User, email: "test@test.com")
      assert user.github_token != "different-token"
    end

    test "when github does not create a new user if already in in db", %{conn: conn} do
      Repo.insert!(%User{email: "test@test.com", github_token: "different-token"})
      conn = get(conn, "/auth/github/callback?code=stuff")
      user_count = Repo.one(from(u in User, select: count("*")))
      assert user_count == 1
    end

    test "when github creates github repos in the db", %{conn: conn} do
      MockReposGrabber.clear()

      MockReposGrabber.insert_repo(%{
        "name" => "Barter",
        "open_issues_count" => 3,
        "owner" => %{"login" => "smcfarlane"}
      })

      conn = get(conn, "/auth/github/callback?code=stuff")
      repo_count = Repo.one(from(r in GithubRepo, select: count("*")))
      assert repo_count == 1
    end

    test "when github associates the github repo with a user", %{conn: conn} do
      MockReposGrabber.clear()

      MockReposGrabber.insert_repo(%{
        "name" => "Barter",
        "open_issues_count" => 3,
        "owner" => %{"login" => "smcfarlane"}
      })

      conn = get(conn, "/auth/github/callback?code=stuff")
      repo = Repo.one(GithubRepo)
      user = Repo.one(User)
      preloaded_repo = Repo.preload(repo, [:user])
      assert preloaded_repo.user == user
    end

    test "when github creates github issues in the db", %{conn: conn} do
      MockReposGrabber.clear()
      SellableIssues.MockIssuesGrabber.clear()

      issues = [
        %{
          "assignee" => nil,
          "assignees" => [],
          "author_association" => "NONE",
          "body" =>
            "Hi, I noticed these `<video>` attributes are missing from the `Attributes` module:\r\n- `crossorigin`\r\n- `mediagroup`\r\n- `muted`\r\nhttps://www.w3.org/TR/html5/embedded-content-0.html#the-video-element\r\n\r\nWould you be interested in a PR?\r\n",
          "closed_at" => nil,
          "comments" => 1,
          "comments_url" => "https://api.github.com/repos/elm-lang/html/issues/154/comments",
          "created_at" => "2017-11-21T15:01:34Z",
          "events_url" => "https://api.github.com/repos/elm-lang/html/issues/154/events",
          "html_url" => "https://github.com/elm-lang/html/issues/154",
          "id" => 275_743_372,
          "labels" => [],
          "labels_url" => "https://api.github.com/repos/elm-lang/html/issues/154/labels{/name}",
          "locked" => false,
          "milestone" => nil,
          "number" => 154,
          "reactions" => %{
            "+1" => 3,
            "-1" => 0,
            "confused" => 0,
            "heart" => 0,
            "hooray" => 0,
            "laugh" => 0,
            "total_count" => 3,
            "url" => "https://api.github.com/repos/elm-lang/html/issues/154/reactions"
          },
          "repository_url" => "https://api.github.com/repos/elm-lang/html",
          "state" => "open",
          "title" => "video attributes missing",
          "updated_at" => "2017-11-21T15:01:34Z",
          "url" => "https://api.github.com/repos/elm-lang/html/issues/154",
          "user" => %{
            "avatar_url" => "https://avatars2.githubusercontent.com/u/78849?v=4",
            "events_url" => "https://api.github.com/users/kwijibo/events{/privacy}",
            "followers_url" => "https://api.github.com/users/kwijibo/followers",
            "following_url" => "https://api.github.com/users/kwijibo/following{/other_user}",
            "gists_url" => "https://api.github.com/users/kwijibo/gists{/gist_id}",
            "gravatar_id" => "",
            "html_url" => "https://github.com/kwijibo",
            "id" => 78849,
            "login" => "kwijibo",
            "organizations_url" => "https://api.github.com/users/kwijibo/orgs",
            "received_events_url" => "https://api.github.com/users/kwijibo/received_events",
            "repos_url" => "https://api.github.com/users/kwijibo/repos",
            "site_admin" => false,
            "starred_url" => "https://api.github.com/users/kwijibo/starred{/owner}{/repo}",
            "subscriptions_url" => "https://api.github.com/users/kwijibo/subscriptions",
            "type" => "User",
            "url" => "https://api.github.com/users/kwijibo"
          }
        }
      ]

      SellableIssues.MockIssuesGrabber.insert_issues(issues)

      MockReposGrabber.insert_repo(%{
        "name" => "Barter",
        "open_issues_count" => 3,
        "owner" => %{"login" => "smcfarlane"}
      })

      conn = get(conn, "/auth/github/callback?code=stuff")
      issue_count = Repo.one(from(r in GithubIssue, select: count("*")))
      assert issue_count == 1
    end

    @valid_attrs %{
      code: "some-code",
      provider: "stripe"
    }
    test "when stripe updates the stripe token", %{conn: conn} do
      user = with {:ok, user} <- Repo.insert!(%User{email: "trodriguez91@icloud.com"}), do: user
      {:ok, jwt, _} = TossBounty.UserManager.Guardian.encode_and_sign(user)

      updatedConn =
        conn
        |> put_req_header("authorization", "Bearer #{jwt}")
        |> Plug.Conn.assign(:current_user, user)

      get(updatedConn, "/auth/stripe/callback?code=stuff")
      user = Repo.one(User)
      assert user.stripe_access_token != "different-token"
    end

    test "when there are multiple github repos with the same name", %{conn: conn} do
      user = with {:ok, user} <- Repo.insert!(%User{email: "trodriguez91@icloud.com"}), do: user
      other_user = with {:ok, user} <- Repo.insert!(%User{email: "another@icloud.com"}), do: user

      MockReposGrabber.clear()

      MockReposGrabber.insert_repo(%{
        "name" => "foobar",
        "open_issues_count" => 3,
        "owner" => %{"login" => "trodrigu"}
      })

      {:ok, jwt, _} = TossBounty.UserManager.Guardian.encode_and_sign(user)

      repo = Repo.insert!(%GithubRepo{name: "foobar", user_id: user.id})
      other_repo = Repo.insert!(%GithubRepo{name: "foobar", user_id: other_user.id})

      updatedConn =
        conn
        |> put_req_header("authorization", "Bearer #{jwt}")
        |> Plug.Conn.assign(:current_user, user)

      get(updatedConn, "/auth/github/callback?code=stuff")
    end
  end
end
