defmodule TossBountyWeb.SearchControllerTest do
  use TossBountyWeb.ApiCase

  alias TossBounty.Campaigns
  alias TossBounty.Campaigns.Campaign
  alias TossBounty.Repo
  alias TossBounty.Accounts.User
  alias TossBounty.Github.GithubRepo


  @create_attrs %{
    current_funding: 120.5,
    funding_goal: 120.5,
    long_description: "some long_description"
  }
  @update_attrs %{
    current_funding: 456.7,
    funding_goal: 456.7,
    long_description: "some updated long_description"
  }
  @invalid_attrs %{
    current_funding: nil,
    funding_goal: nil,
    long_description: nil
  }

  setup config = %{conn: conn, current_user: current_user} do
    user =
      case current_user do
        %User{} ->
          current_user

        _ ->
          insert_user(name: "tommy", email: "some_email@test.com")
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

  def create_fixture_campaign(relationships \\ %{}, campaign_attrs \\ %{}) do
    user = relationships[:user]
    github_repo = relationships[:github_repo]

    updated_campaign_attrs =
      campaign_attrs
      |> Enum.into(%{
          long_description: "a longer description",
          funding_goal: 20000.00,
          user_id: user.id,
          github_repo_id: github_repo.id
                   })

    {:ok, campaign} =
        updated_campaign_attrs
        |> Campaigns.create_campaign()

    {:ok, user: user, github_repo: github_repo, campaign: campaign}
  end

  describe "index" do
    setup [:create_fixture_github_repo, :create_fixture_campaign]
    @tag :authenticated
    test "renders index of resources matching github repo name", %{conn: conn, user: user} do
      github_repo_attrs = %{
        name: "dude",
        owner: "dude",
        bountiful_score: 5,
        image: "an-img-path",
        user_id: user.id
      }

      {:ok, github_repo} =
        %GithubRepo{}
        |> GithubRepo.changeset(github_repo_attrs)
        |> Repo.insert()

      updated_campaign_attrs = %{
            long_description: "a longer description",
            funding_goal: 20000.00,
            user_id: user.id,
            github_repo_id: github_repo.id
      }

      {:ok, campaign} =
        updated_campaign_attrs
        |> Campaigns.create_campaign()

      conn = get(conn, search_path(conn, :index, %{page: 1, page_size: 5, search: "name"}))
      assert conn |> json_response(200)
      data = json_response(conn, 200)["data"]
      assert Enum.count(data) == 1
    end

    @tag :authenticated
    test "renders index of resources matching user name", %{conn: conn, user: user} do
      other_user = insert_user(name: "another dev", email: "some_other_email@test.com")

      github_repo_attrs = %{
        name: "dude",
        owner: "dude",
        bountiful_score: 5,
        image: "an-img-path",
        user_id: other_user.id
      }

      {:ok, github_repo} =
        %GithubRepo{}
        |> GithubRepo.changeset(github_repo_attrs)
        |> Repo.insert()

      updated_campaign_attrs = %{
        long_description: "a longer description",
        funding_goal: 20000.00,
        user_id: user.id,
        github_repo_id: github_repo.id
      }

      {:ok, campaign} =
        updated_campaign_attrs
        |> Campaigns.create_campaign()

      conn = get(conn, search_path(conn, :index, %{page: 1, page_size: 5, search: "another"}))
      assert conn |> json_response(200)
      data = json_response(conn, 200)["data"]
      assert Enum.count(data) == 1
    end
  end
end
