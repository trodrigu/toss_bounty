defmodule TossBounty.MessageThreadControllerTest do
  use TossBounty.ConnCase

  alias TossBounty.MessageThread
  alias TossBounty.Repo

  @valid_attrs %{active: true, board_id: 42, title: "some content"}
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
    conn = get conn, message_thread_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    message_thread = Repo.insert! %MessageThread{}
    conn = get conn, message_thread_path(conn, :show, message_thread)
    data = json_response(conn, 200)["data"]
    assert data["id"] == "#{message_thread.id}"
    assert data["type"] == "message-thread"
    assert data["attributes"]["board_id"] == message_thread.board_id
    assert data["attributes"]["title"] == message_thread.title
    assert data["attributes"]["active"] == message_thread.active
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, message_thread_path(conn, :create), %{
      "meta" => %{},
      "data" => %{
        "type" => "message_thread",
        "attributes" => @valid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(MessageThread, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, message_thread_path(conn, :create), %{
      "meta" => %{},
      "data" => %{
        "type" => "message_thread",
        "attributes" => @invalid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    message_thread = Repo.insert! %MessageThread{}
    conn = put conn, message_thread_path(conn, :update, message_thread), %{
      "meta" => %{},
      "data" => %{
        "type" => "message_thread",
        "id" => message_thread.id,
        "attributes" => @valid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(MessageThread, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    message_thread = Repo.insert! %MessageThread{}
    conn = put conn, message_thread_path(conn, :update, message_thread), %{
      "meta" => %{},
      "data" => %{
        "type" => "message_thread",
        "id" => message_thread.id,
        "attributes" => @invalid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    message_thread = Repo.insert! %MessageThread{}
    conn = delete conn, message_thread_path(conn, :delete, message_thread)
    assert response(conn, 204)
    refute Repo.get(MessageThread, message_thread.id)
  end

end
