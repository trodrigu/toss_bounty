defmodule TossBountyWeb.UserControllerTest do
  use TossBountyWeb.ApiCase
  import TossBountyWeb.AuthenticationTestHelpers
  alias TossBounty.Accounts.User

  @valid_attrs %{
    name: "Test User",
    email: "test@user.com",
    stripe_external_id: "1dsfs23jkl",
    stripe_access_token: "324jkkljkljfsdfjkl4325sdfjklb"
  }
  @update_attrs %{
    name: "test user",
    role: 0
  }

  @invalid_attrs %{
    name: "",
    email: ""
  }
  defp dasherize_keys(attrs) do
    Enum.map(attrs, fn {k, v} -> {JaSerializer.Formatter.Utils.format_key(k), v} end)
    |> Enum.into(%{})
  end

  describe "create" do
    @tag :authenticated
    test "creates and renders resource when data is valid", %{conn: conn} do
      attrs = Map.put(@valid_attrs, :password, "password")

      conn =
        post(conn, user_path(conn, :create), %{
          "data" => %{
            "attributes" => attrs
          }
        })

      assert conn |> json_response(201)
    end
  end

  describe "update user" do
    setup %{conn: conn} do
      conn =
        conn
        |> put_req_header("accept", "application/vnd.api+json")
        |> put_req_header("content-type", "application/vnd.api+json")

      user = Repo.insert!(%TossBounty.Accounts.User{name: "some name", role: 0})
      {:ok, conn: conn, user: user}
    end

    @tag :authenticated
    test "renders user when data is valid", %{conn: conn, user: %User{id: id} = user} do
      conn =
        put(conn, user_path(conn, :update, user), %{
          "meta" => %{},
          "data" => %{
            "type" => "user",
            "attributes" => dasherize_keys(@update_attrs)
          }
        })

      data = json_response(conn, 200)["data"]
      assert data["id"] == "#{id}"
      assert data["type"] == "user"
      assert data["attributes"]["name"] == "some name"
      assert data["attributes"]["role"] == 0
    end
  end
end
