defmodule TossBountyWeb.StripeTokenControllerTest do
  use TossBountyWeb.ApiCase, resource_name: :token
  alias TossBounty.StripeProcessing.Token
  alias TossBounty.Repo
  alias TossBounty.Accounts.User

  @create_attrs %{
    uuid: "some-token-1"
  }
  @update_attrs %{
    uuid: "some-token-1"
  }
  @invalid_attrs %{
    uuid: nil
  }

  defp dasherize_keys(attrs) do
    Enum.map(attrs, fn {k, v} -> {JaSerializer.Formatter.Utils.format_key(k), v} end)
    |> Enum.into(%{})
  end

  defp relationships do
    user = Repo.insert!(%TossBounty.Accounts.User{})

    %{
      "user" => %{
        "data" => %{
          "type" => "user",
          "id" => user.id
        }
      }
    }
  end

  setup %{conn: conn} do
    conn =
      conn
      |> put_req_header("accept", "application/vnd.api+json")
      |> put_req_header("content-type", "application/vnd.api+json")

    user = Repo.insert!(%User{})
    {:ok, conn: conn, user_id: user.id}
  end

  describe "create token" do
    @tag :authenticated
    test "renders token when data is valid", %{conn: conn} do
      conn =
        post(conn, stripe_token_path(conn, :create), %{
          "meta" => %{},
          "data" => %{
            "type" => "token",
            "attributes" => dasherize_keys(@create_attrs),
            "relationships" => relationships
          }
        })

      assert %{"id" => id} = json_response(conn, 201)["data"]
    end

    @tag :authenticated
    test "renders errors when data is invalid", %{conn: conn} do
      conn =
        post(conn, stripe_token_path(conn, :create), %{
          "meta" => %{},
          "data" => %{
            "type" => "token",
            "attributes" => dasherize_keys(@invalid_attrs),
            "relationships" => relationships
          }
        })

      assert json_response(conn, 422)["errors"] != %{}
    end

    test "renders 401 when not authenticated", %{conn: conn} do
      conn =
        post(conn, stripe_token_path(conn, :create), %{
          "meta" => %{},
          "data" => %{
            "type" => "token",
            "attributes" => dasherize_keys(@create_attrs),
            "relationships" => relationships
          }
        })

      assert json_response(conn, 401)["errors"] != %{}
    end
  end
end
