defmodule TossBountyWeb.CampaignControllerTest do
  use TossBountyWeb.ConnCase

  alias TossBountyWeb.Campaigns
  alias TossBountyWeb.Campaigns.Campaign
  alias TossBounty.Repo
  alias TossBountyWeb.User

  @create_attrs %{
    current_funding: 120.5,
    funding_end_date: ~N[2010-04-17 14:00:00.000000],
    funding_goal: 120.5,
    long_description: "some long_description",
    short_description: "some short_description",
  }
  @update_attrs %{
    current_funding: 456.7,
    funding_end_date: ~N[2011-05-18 15:01:01.000000],
    funding_goal: 456.7,
    long_description: "some updated long_description",
    short_description: "some updated short_description",
  }
  @invalid_attrs %{
    current_funding: nil,
    funding_end_date: nil,
    funding_goal: nil,
    long_description: nil,
    short_description: nil,
  }

  def fixture(:campaign) do
    user = Repo.insert!(%TossBountyWeb.User{})
    attrs = Map.put(@create_attrs, :user_id, user.id)
    {:ok, campaign} = Campaigns.create_campaign(attrs)
    campaign
  end

  defp dasherize_keys(attrs) do
    Enum.map(attrs, fn {k, v} -> {JaSerializer.Formatter.Utils.format_key(k), v} end)
    |> Enum.into(%{})
  end

  defp relationships do
    user = Repo.insert!(%TossBountyWeb.User{})

    %{
      "user" => %{
        "data" => %{
          "type" => "user",
          "id" => user.id
        }
      },
    }
  end

  setup %{conn: conn} do
    conn = conn
      |> put_req_header("accept", "application/vnd.api+json")
      |> put_req_header("content-type", "application/vnd.api+json")

    {:ok, conn: conn}
  end

  describe "index" do
    test "lists all campaigns", %{conn: conn} do
      conn = get conn, campaign_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create campaign" do
    test "renders campaign when data is valid", %{conn: conn} do
      conn = post conn, campaign_path(conn, :create), %{
        "meta" => %{},
        "data" => %{
          "type" => "campaign",
          "attributes" => dasherize_keys(@create_attrs),
          "relationships" => relationships
        }
      }
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, campaign_path(conn, :show, id)
      data = json_response(conn, 200)["data"]
      assert data["id"] == "#{id}"
      assert data["type"] == "campaign"
      assert data["attributes"]["current-funding"] == 120.5
      assert data["attributes"]["funding-end-date"] == "2010-04-17T14:00:00.000000"
      assert data["attributes"]["funding-goal"] == 120.5
      assert data["attributes"]["long-description"] == "some long_description"
      assert data["attributes"]["short-description"] == "some short_description"

    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, campaign_path(conn, :create), %{
        "meta" => %{},
        "data" => %{
          "type" => "campaign",
          "attributes" => dasherize_keys(@invalid_attrs),
          "relationships" => relationships
        }
      }
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update campaign" do
    setup [:create_campaign]

    test "renders campaign when data is valid", %{conn: conn, campaign: %Campaign{id: id} = campaign} do
      conn = put conn, campaign_path(conn, :update, campaign), %{
        "meta" => %{},
        "data" => %{
          "type" => "campaign",
          "id" => "#{campaign.id}",
          "attributes" => dasherize_keys(@update_attrs),
          "relationships" => relationships
        }
      }
      data = json_response(conn, 200)["data"]
      assert data["id"] == "#{id}"
      assert data["type"] == "campaign"
      assert data["attributes"]["current-funding"] == 456.7
      assert data["attributes"]["funding-end-date"] == "2011-05-18T15:01:01.000000"
      assert data["attributes"]["funding-goal"] == 456.7
      assert data["attributes"]["long-description"] == "some updated long_description"
      assert data["attributes"]["short-description"] == "some updated short_description"


      conn = get conn, campaign_path(conn, :show, id)
      data = json_response(conn, 200)["data"]
      assert data["id"] == "#{id}"
      assert data["type"] == "campaign"
      assert data["attributes"]["current-funding"] == 456.7
      assert data["attributes"]["funding-end-date"] == "2011-05-18T15:01:01.000000"
      assert data["attributes"]["funding-goal"] == 456.7
      assert data["attributes"]["long-description"] == "some updated long_description"
      assert data["attributes"]["short-description"] == "some updated short_description"

    end

    test "renders errors when data is invalid", %{conn: conn, campaign: campaign} do
      conn = put conn, campaign_path(conn, :update, campaign), %{
      "meta" => %{},
      "data" => %{
        "type" => "campaign",
        "id" => "#{campaign.id}",
        "attributes" => dasherize_keys(@invalid_attrs),
        "relationships" => relationships
      }
    }
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete campaign" do
    setup [:create_campaign]

    test "deletes chosen campaign", %{conn: conn, campaign: campaign} do
      conn = delete conn, campaign_path(conn, :delete, campaign)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, campaign_path(conn, :show, campaign)
      end
    end
  end

  defp create_campaign(attrs) do
    campaign = fixture(:campaign)
    {:ok, campaign: campaign}
  end
end
