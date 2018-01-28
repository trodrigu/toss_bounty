defmodule TossBountyWeb.CustomerControllerTest do
  use TossBountyWeb.ApiCase, resource_name: :customer
  alias TossBounty.StripeProcessing.Customer
  alias TossBounty.Repo
  alias TossBounty.Accounts.User

  defp dasherize_keys(attrs) do
    Enum.map(attrs, fn {k, v} -> {JaSerializer.Formatter.Utils.format_key(k), v} end)
    |> Enum.into(%{})
  end

  defp relationships do
    token = Repo.insert!(%TossBounty.StripeProcessing.Token{})

    %{
      "token" => %{
        "data" => %{
          "type" => "token",
          "id" => token.id
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

  describe "create customer" do
    @tag :authenticated
    test "renders customer when data is valid", %{conn: conn} do
      conn =
        post(conn, customer_path(conn, :create), %{
          "meta" => %{},
          "data" => %{
            "type" => "customer",
            "relationships" => relationships
          }
        })

      assert %{"id" => id} = json_response(conn, 201)["data"]
    end

    @tag :authenticated
    test "renders errors when data is invalid", %{conn: conn} do
      conn =
        post(conn, customer_path(conn, :create), %{
          "meta" => %{},
          "data" => %{
            "type" => "customer"
          }
        })

      assert json_response(conn, 422)["errors"] != %{}
    end

    test "renders 401 when not authenticated", %{conn: conn} do
      conn =
        post(conn, customer_path(conn, :create), %{
          "meta" => %{},
          "data" => %{
            "type" => "customer",
            "relationships" => relationships
          }
        })

      assert json_response(conn, 401)["errors"] != %{}
    end
  end
end
