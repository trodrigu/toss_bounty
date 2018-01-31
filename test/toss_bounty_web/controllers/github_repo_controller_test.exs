defmodule TossBountyWeb.GithubRepoControllerTest do
  use TossBountyWeb.ApiCase
  alias TossBounty.Github.GithubIssue
  alias TossBounty.Github.GithubRepo
  alias TossBounty.Accounts.User

  setup %{current_user: current_user} do
    user =
      case current_user do
        %User{} ->
          current_user

        _ ->
          insert_user(email: "some_email@test.com")
      end

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

  describe "index" do
    @tag :authenticated
    test "returns an index of the github repos", %{conn: conn} do
      conn = get(conn, github_repo_path(conn, :index))
      assert conn |> json_response(200)
    end

    @tag :authenticated
    test "filter by user id returns the correct repo", %{conn: conn} do
      user = Repo.get_by(User, email: "test@test.com")
      repo = Repo.insert!(%GithubRepo{name: "foobar", user_id: user.id})
      _repo_that_does_not_matter = Repo.insert!(%GithubRepo{name: "bazbar"})
      Repo.insert!(%GithubIssue{title: "great title", body: "body", github_repo_id: repo.id})

      user = Repo.one(from(u in User, limit: 1))
      {:ok, jwt, _} = Guardian.encode_and_sign(user)

      conn =
        build_conn()
        |> put_req_header("authorization", "Bearer #{jwt}")
        |> get(github_repo_path(conn, :index), %{user_id: user.id})

      response = json_response(conn, 200)

      repo_from_response =
        response["data"]
        |> Enum.at(0)

      repos_name = repo_from_response["attributes"]["name"]
      assert repos_name == "foobar"
    end
  end

  describe "show" do
    setup [:create_fixture_github_repo]

    @tag :authenticated
    test "shows the github repo", %{conn: conn, github_repo: github_repo} do
      conn = get(conn, github_repo_path(conn, :show, github_repo.id))
      data = json_response(conn, 200)["data"]
      assert data["id"] == "#{github_repo.id}"
      assert data["type"] == "github-repo"
      assert data["attributes"]["name"] == "a name"
      assert data["attributes"]["owner"] == "an owner"
      assert data["attributes"]["bountiful-score"] == 5
      assert data["attributes"]["image"] == "an-img-path"
    end
  end
end
