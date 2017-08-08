defmodule TossBounty.UserControllerTest do
  use TossBounty.ApiCase
  import TossBounty.AuthenticationTestHelpers

  @valid_attrs %{
    name: "Test User",
    email: "test@user.com",
    username: "testuser"
  }

  @invalid_attrs %{
    name: "",
    email: "",
    username: ""
  }

  describe "create" do
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
