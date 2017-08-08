defmodule TossBounty.BoardControllerTest do
  use TossBounty.ConnCase

  alias TossBounty.Board
  alias TossBounty.Repo

  @valid_attrs %{latitude: "120.5", longitude: "120.5", needed_by: %{day: 17, month: 4, year: 2010}, skill_needed: 42, skill_offered: 42, status: "some content", user_id: 42}
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
    conn = get conn, board_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    board = Repo.insert! %Board{}
    conn = get conn, board_path(conn, :show, board)
    data = json_response(conn, 200)["data"]
    assert data["id"] == "#{board.id}"
    assert data["type"] == "board"
    assert data["attributes"]["user_id"] == board.user_id
    assert data["attributes"]["skill_needed"] == board.skill_needed
    assert data["attributes"]["skill_offered"] == board.skill_offered
    assert data["attributes"]["status"] == board.status
    assert data["attributes"]["needed_by"] == board.needed_by
    assert data["attributes"]["longitude"] == board.longitude
    assert data["attributes"]["latitude"] == board.latitude
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, board_path(conn, :create), %{
      "meta" => %{},
      "data" => %{
        "type" => "board",
        "attributes" => @valid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Board, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, board_path(conn, :create), %{
      "meta" => %{},
      "data" => %{
        "type" => "board",
        "attributes" => @invalid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    board = Repo.insert! %Board{}
    conn = put conn, board_path(conn, :update, board), %{
      "meta" => %{},
      "data" => %{
        "type" => "board",
        "id" => board.id,
        "attributes" => @valid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Board, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    board = Repo.insert! %Board{}
    conn = put conn, board_path(conn, :update, board), %{
      "meta" => %{},
      "data" => %{
        "type" => "board",
        "id" => board.id,
        "attributes" => @invalid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    board = Repo.insert! %Board{}
    conn = delete conn, board_path(conn, :delete, board)
    assert response(conn, 204)
    refute Repo.get(Board, board.id)
  end

end
