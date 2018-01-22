defmodule TossBountyWeb.RewardControllerTest do
  use TossBountyWeb.ApiCase, resource_name: :reward

  alias TossBounty.Incentive
  alias TossBounty.Incentive.Reward
  alias TossBounty.Accounts.User


  @create_attrs %{
    description: "some description",
    donation_level: 120.5,
  }
  @update_attrs %{
    description: "some updated description",
    donation_level: 456.7,
  }
  @invalid_attrs %{
    description: nil,
    donation_level: nil,
  }

  def fixture(:reward, user) do
    campaign = Repo.insert!(%TossBounty.Campaigns.Campaign{user_id: user.id})
    attrs = Map.put(@create_attrs, :campaign_id, campaign.id)
    {:ok, reward} = Incentive.create_reward(attrs)
    reward
  end
  def fixture(:reward) do
    campaign = Repo.insert!(%TossBounty.Campaigns.Campaign{})
    attrs = Map.put(@create_attrs, :campaign_id, campaign.id)
    {:ok, reward} = Incentive.create_reward(attrs)
    reward
  end

  defp dasherize_keys(attrs) do
    Enum.map(attrs, fn {k, v} -> {JaSerializer.Formatter.Utils.format_key(k), v} end)
    |> Enum.into(%{})
  end

  defp relationships do
    campaign = Repo.insert!(%TossBounty.Campaigns.Campaign{})

    %{
      "campaign" => %{
        "data" => %{
          "type" => "campaign",
          "id" => campaign.id
        }
      }
    }
  end

  setup %{conn: conn} do
    conn = conn
    |> put_req_header("accept", "application/vnd.api+json")
    |> put_req_header("content-type", "application/vnd.api+json")

    campaign = Repo.insert!(%TossBounty.Campaigns.Campaign{})
    {:ok, conn: conn, campaign_id: campaign.id}
  end

  describe "index" do
    @tag :authenticated
    test "lists all rewards", %{conn: conn} do
      conn = get conn, reward_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end

    @tag :authenticated
    test "lists rewards filtered by campaign id", %{conn: conn, campaign_id: campaign_id} do
      reward = Repo.insert!(%TossBounty.Incentive.Reward{campaign_id: campaign_id})
      other_reward = Repo.insert!(%TossBounty.Incentive.Reward{})
      conn = get conn, reward_path(conn, :index, %{"campaign_id" => campaign_id})
      data = json_response(conn, 200)["data"]
      assert Enum.count( data ) == 1
    end
  end

  describe "create reward" do
    @tag :authenticated
    test "renders reward when data is valid", %{conn: conn} do
      conn = post conn, reward_path(conn, :create), %{
        "meta" => %{},
        "data" => %{
          "type" => "reward",
          "attributes" => dasherize_keys(@create_attrs),
          "relationships" => relationships
        }
      }
      assert %{"id" => id} = json_response(conn, 201)["data"]

      user = Repo.one(from u in User, limit: 1)
      {:ok, jwt, _} = Guardian.encode_and_sign(user)

      build_conn()
      |> put_req_header("authorization", "Bearer #{jwt}")
      |> get( reward_path(conn, :show, id) )

      assert json_response(conn, 201)["data"] == %{
        "id" => id,
        "type" => "reward",
        "attributes" => %{
          "description" => "some description",
          "donation-level" => 120.5
          }
        }
    end

    @tag :authenticated
    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, reward_path(conn, :create), %{
        "meta" => %{},
        "data" => %{
          "type" => "reward",
          "attributes" => dasherize_keys(@invalid_attrs),
          "relationships" => relationships
        }
      }
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update reward" do
    setup [:create_reward]

    @tag :authenticated
    test "renders reward when data is valid", %{conn: conn, reward: %Reward{id: id} = reward} do
      conn = put conn, reward_path(conn, :update, reward), %{
        "meta" => %{},
        "data" => %{
          "type" => "reward",
          "attributes" => dasherize_keys(@update_attrs),
          "relationships" => relationships
        }
      }
      data = json_response(conn, 200)["data"]
      assert data["id"] == "#{id}"
      assert data["type"] == "reward"
      assert data["attributes"]["description"] == "some updated description"
      assert data["attributes"]["donation-level"] == 456.7
    end

    @tag :authenticated
    test "renders errors when data is invalid", %{conn: conn, reward: reward} do
      conn = put conn, reward_path(conn, :update, reward), %{
        "meta" => %{},
        "data" => %{
          "type" => "reward",
          "attributes" => dasherize_keys(@invalid_attrs),
          "relationships" => relationships
        }
      }
      assert json_response(conn, 422)["errors"] != %{}
    end

    @tag :authenticated
    test "renders errors when not authorized", %{conn: conn, reward: reward} do
      another_user = insert_user(email: "test2@test.com")
      another_reward_from_different_user =
        fixture(:reward, another_user)
      conn = put conn, reward_path(conn, :update, another_reward_from_different_user), %{
        "meta" => %{},
        "data" => %{
          "type" => "reward",
          "attributes" => dasherize_keys(@update_attrs),
          "relationships" => relationships
        }
      }
      assert json_response(conn, 403)["errors"] != %{}
    end
  end

  describe "delete reward" do
    setup [:create_reward]

    @tag :authenticated
    test "deletes chosen reward", %{conn: conn, reward: reward} do
      conn = delete conn, reward_path(conn, :delete, reward)
      assert response(conn, 204)

      user = Repo.one(from u in User, limit: 1)
      {:ok, jwt, _} = Guardian.encode_and_sign(user)
      assert_error_sent 404, fn ->
        build_conn()
        |> put_req_header("authorization", "Bearer #{jwt}")
        |> get( reward_path(conn, :show, reward) )
      end
    end

    @tag :authenticated
    test "renders errors when not authorized", %{conn: conn, reward: reward} do
      another_user = insert_user(email: "test2@test.com")
      another_reward_from_different_user =
        fixture(:reward, another_user)
      conn = delete conn, reward_path(conn, :delete, another_reward_from_different_user)
      assert json_response(conn, 403)["errors"] != %{}
    end
  end

  defp create_reward(attrs) do
    reward = fixture(:reward, attrs[:current_user])
    {:ok, reward: reward}
  end
  defp create_reward(_) do
    reward = fixture(:reward)
    {:ok, reward: reward}
  end
end
