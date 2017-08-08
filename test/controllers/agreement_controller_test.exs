defmodule TossBounty.AgreementControllerTest do
  use TossBounty.ConnCase

  alias TossBounty.Agreement
  alias TossBounty.Repo

  @valid_attrs %{board_id: 42, details: "some content"}
  @invalid_attrs %{}

  setup do
    conn = build_conn()
      |> put_req_header("accept", "application/vnd.api+json")
      |> put_req_header("content-type", "application/vnd.api+json")

    {:ok, conn: conn}
  end

  defp relationships do
    %{}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, agreement_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    agreement = Repo.insert! %Agreement{}
    conn = get conn, agreement_path(conn, :show, agreement)
    data = json_response(conn, 200)["data"]
    assert data["id"] == "#{agreement.id}"
    assert data["type"] == "agreement"
    assert data["attributes"]["board_id"] == agreement.board_id
    assert data["attributes"]["details"] == agreement.details
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, agreement_path(conn, :create), %{
      "meta" => %{},
      "data" => %{
        "type" => "agreement",
        "attributes" => @valid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Agreement, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, agreement_path(conn, :create), %{
      "meta" => %{},
      "data" => %{
        "type" => "agreement",
        "attributes" => @invalid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    agreement = Repo.insert! %Agreement{}
    conn = put conn, agreement_path(conn, :update, agreement), %{
      "meta" => %{},
      "data" => %{
        "type" => "agreement",
        "id" => agreement.id,
        "attributes" => @valid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Agreement, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    agreement = Repo.insert! %Agreement{}
    conn = put conn, agreement_path(conn, :update, agreement), %{
      "meta" => %{},
      "data" => %{
        "type" => "agreement",
        "id" => agreement.id,
        "attributes" => @invalid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    agreement = Repo.insert! %Agreement{}
    conn = delete conn, agreement_path(conn, :delete, agreement)
    assert response(conn, 204)
    refute Repo.get(Agreement, agreement.id)
  end

end
