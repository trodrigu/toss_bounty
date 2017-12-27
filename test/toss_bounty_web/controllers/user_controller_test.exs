defmodule TossBountyWeb.UserControllerTest do
  use TossBountyWeb.ApiCase
  import TossBountyWeb.AuthenticationTestHelpers

  @valid_attrs %{
    name: "Test User",
    email: "test@user.com",
    stripe_external_id: "1dsfs23jkl",
    stripe_access_token: "324jkkljkljfsdfjkl4325sdfjklb"
  }

  @invalid_attrs %{
    name: "",
    email: "",
  }

  describe "create" do
    @tag :authenticated
    test "creates and renders resource when data is valid", %{conn: conn} do
      attrs = Map.put(@valid_attrs, :password, "password")
      conn = post conn, user_path(conn, :create), %{
        "data" => %{
          "attributes" => attrs
        }
      }
      assert conn |> json_response(201)
    end
  end
end
