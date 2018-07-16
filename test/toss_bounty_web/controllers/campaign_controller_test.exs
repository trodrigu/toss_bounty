defmodule TossBountyWeb.CampaignControllerTest do
  use TossBountyWeb.ApiCase, resource_name: :campaign

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

  def fixture(:campaign, nil) do
    user = Repo.insert!(%User{email: "another@test.com"})
    repo = Repo.insert!(%GithubRepo{name: "foobar", user_id: user.id})

    attrs = Map.put(@create_attrs, :user_id, user.id)
    attrs_with_github_repo_id = Map.put(attrs, :github_repo_id, repo.id)
    {:ok, campaign} = Campaigns.create_campaign(attrs_with_github_repo_id)
    campaign
  end

  def fixture(:campaign, user) do
    repo = Repo.insert!(%GithubRepo{name: "foobar", user_id: user.id})

    attrs = Map.put(@create_attrs, :user_id, user.id)
    attrs_with_github_repo_id = Map.put(attrs, :github_repo_id, repo.id)
    {:ok, campaign} = Campaigns.create_campaign(attrs_with_github_repo_id)
    campaign
  end

  defp dasherize_keys(attrs) do
    Enum.map(attrs, fn {k, v} -> {JaSerializer.Formatter.Utils.format_key(k), v} end)
    |> Enum.into(%{})
  end

  defp relationships do
    user = Repo.insert!(%TossBounty.Accounts.User{})
    repo = Repo.insert!(%GithubRepo{name: "foobar", user_id: user.id})

    %{
      "user" => %{
        "data" => %{
          "type" => "user",
          "id" => user.id
        }
      },
      "github_repo" => %{
        "data" => %{
          "type" => "github_repo",
          "id" => repo.id
        }
      }
    }
  end

  setup %{conn: conn} do
    conn =
      conn
      |> put_req_header("accept", "application/vnd.api+json")
      |> put_req_header("content-type", "application/vnd.api+json")

    user = Repo.insert!(%TossBounty.Accounts.User{})
    {:ok, conn: conn, user_id: user.id}
  end

  describe "index" do
    @tag :authenticated
    test "lists all campaigns", %{conn: conn, user_id: user_id} do
      campaign = Repo.insert!(%TossBounty.Campaigns.Campaign{user_id: user_id})
      conn = get(conn, campaign_path(conn, :index))
      assert Enum.count(json_response(conn, 200)["data"]) == 1
    end

    @tag :authenticated
    test "lists campaigns filtered by user id", %{conn: conn, user_id: user_id} do
      campaign = Repo.insert!(%TossBounty.Campaigns.Campaign{user_id: user_id})
      other_campaign = Repo.insert!(%TossBounty.Campaigns.Campaign{})
      conn = get(conn, campaign_path(conn, :index, %{user_id: user_id, page: 1, page_size: 10}))
      data = json_response(conn, 200)["data"]
      assert Enum.count(data) == 1
    end

    @tag :authenticated
    test "allows pagination of campaigns", %{conn: conn, user_id: user_id} do
      for _ <- 1..10, do: Repo.insert!(%TossBounty.Campaigns.Campaign{user_id: user_id})

      conn = get(conn, campaign_path(conn, :index, %{user_id: user_id, page: 1, page_size: 5}))
      data = json_response(conn, 200)["data"]
      assert Enum.count(data) == 5
    end

    test "renders 401 when not authenticated", %{conn: conn} do
      conn
      |> request_index
      |> json_response(401)
    end
  end

  describe "create campaign" do
    @tag :authenticated
    test "renders campaign when data is valid", %{conn: conn} do
      conn =
        post(conn, campaign_path(conn, :create), %{
          "meta" => %{},
          "data" => %{
            "type" => "campaign",
            "attributes" => dasherize_keys(@create_attrs),
            "relationships" => relationships
          }
        })

      assert %{"id" => id} = json_response(conn, 201)["data"]

      user = Repo.one(from(u in User, limit: 1))
      {:ok, jwt, _} = Guardian.encode_and_sign(user)

      conn()
      |> put_req_header("authorization", "Bearer #{jwt}")
      |> get(campaign_path(conn, :show, id))

      data = json_response(conn, 201)["data"]
      assert data["id"] == "#{id}"
      assert data["type"] == "campaign"
      assert data["attributes"]["current-funding"] == 120.5
      assert data["attributes"]["funding-goal"] == 120.5
      assert data["attributes"]["long-description"] == "some long_description"
    end

    @tag :authenticated
    test "renders errors when data is invalid", %{conn: conn} do
      conn =
        post(conn, campaign_path(conn, :create), %{
          "meta" => %{},
          "data" => %{
            "type" => "campaign",
            "attributes" => dasherize_keys(@invalid_attrs),
            "relationships" => relationships
          }
        })

      assert json_response(conn, 422)["errors"] != %{}
    end

    test "renders 401 when not authenticated", %{conn: conn} do
      conn
      |> request_index
      |> json_response(401)
    end
  end

  describe "update campaign" do
    setup [:create_campaign]

    @tag :authenticated
    test "renders campaign when data is valid", %{
      conn: conn,
      campaign: %Campaign{id: id} = campaign
    } do
      conn =
        put(conn, campaign_path(conn, :update, campaign), %{
          "meta" => %{},
          "data" => %{
            "type" => "campaign",
            "id" => "#{campaign.id}",
            "attributes" => dasherize_keys(@update_attrs),
            "relationships" => relationships
          }
        })

      data = json_response(conn, 200)["data"]
      assert data["id"] == "#{id}"
      assert data["type"] == "campaign"
      assert data["attributes"]["current-funding"] == 456.7
      assert data["attributes"]["funding-goal"] == 456.7
      assert data["attributes"]["long-description"] == "some updated long_description"

      user = Repo.one(from(u in User, limit: 1))
      {:ok, jwt, _} = Guardian.encode_and_sign(user)

      conn()
      |> put_req_header("authorization", "Bearer #{jwt}")
      |> get(campaign_path(conn, :show, id))

      data = json_response(conn, 200)["data"]
      assert data["id"] == "#{id}"
      assert data["type"] == "campaign"
      assert data["attributes"]["current-funding"] == 456.7
      assert data["attributes"]["funding-goal"] == 456.7
      assert data["attributes"]["long-description"] == "some updated long_description"
    end

    @tag :authenticated
    test "renders errors when data is invalid", %{conn: conn, campaign: campaign} do
      conn =
        put(conn, campaign_path(conn, :update, campaign), %{
          "meta" => %{},
          "data" => %{
            "type" => "campaign",
            "id" => "#{campaign.id}",
            "attributes" => dasherize_keys(@invalid_attrs),
            "relationships" => relationships
          }
        })

      json_response(conn, 422)["errors"]

      assert json_response(conn, 422)["errors"] != %{}
    end

    @tag :authenticated
    test "renders errors when not authorized", %{conn: conn, campaign: campaign} do
      another_user = insert_user(email: "test2@test.com")
      another_campaign_from_different_user = fixture(:campaign, another_user)

      conn =
        put(conn, campaign_path(conn, :update, another_campaign_from_different_user), %{
          "meta" => %{},
          "data" => %{
            "type" => "campaign",
            "id" => "#{another_campaign_from_different_user.id}",
            "attributes" => dasherize_keys(@invalid_attrs),
            "relationships" => relationships
          }
        })

      assert json_response(conn, 403)["errors"] != %{}
    end

    test "renders 401 when not authenticated", %{conn: conn} do
      conn
      |> request_index
      |> json_response(401)
    end
  end

  describe "delete campaign" do
    setup [:create_campaign]

    @tag :authenticated
    test "deletes chosen campaign", %{conn: conn, campaign: campaign} do
      conn = delete(conn, campaign_path(conn, :delete, campaign))
      assert response(conn, 204)

      user = Repo.one(from(u in User, limit: 1))
      {:ok, jwt, _} = Guardian.encode_and_sign(user)

      assert_error_sent(404, fn ->
        conn()
        |> put_req_header("authorization", "Bearer #{jwt}")
        |> get(campaign_path(conn, :show, campaign))
      end)
    end

    @tag :authenticated
    test "renders errors when not authorized", %{conn: conn, campaign: campaign} do
      another_user = insert_user(email: "test2@test.com")
      another_campaign_from_different_user = fixture(:campaign, another_user)
      conn = delete(conn, campaign_path(conn, :delete, another_campaign_from_different_user))
      assert json_response(conn, 403)["errors"] != %{}
    end

    test "renders 401 when not authenticated", %{conn: conn, campaign: campaign} do
      conn = delete(conn, campaign_path(conn, :delete, campaign))
      assert conn |> json_response(401)
    end
  end

  defp create_campaign(attrs) do
    campaign = fixture(:campaign, attrs[:current_user])
    {:ok, campaign: campaign}
  end
end
