defmodule TossBounty.GitHubIssueControllerTest do
  use TossBounty.ApiCase
  import TossBounty.AuthenticationTestHelpers

  @valid_attrs %{
    title: "some title",
    body: "some awesome body",
  }

  @invalid_attrs %{}

  setup %{conn: conn} do
    conn =
      conn
      |> put_req_header("accept", "application/vnd.api+json")
      |> put_req_header("content-type", "application/vnd.api+json")

    {:ok, conn: conn}
  end

  describe "index" do
    test "renders index of resources", %{conn: conn} do
      conn = get conn, git_hub_issue_path(conn, :index), %{
        "data" => %{
        "attributes" => @valid_attrs
        }
      }
      assert conn |> json_response(201)
    end
  end
end
