defmodule TossBounty.MessageControllerTest do
  use TossBounty.ConnCase

  alias TossBounty.Message
  alias TossBounty.Repo

  @valid_attrs %{message_thread_id: 42, text: "some content", user_id: 42}
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
    conn = get conn, message_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    message = Repo.insert! %Message{}
    conn = get conn, message_path(conn, :show, message)
    data = json_response(conn, 200)["data"]
    assert data["id"] == "#{message.id}"
    assert data["type"] == "message"
    assert data["attributes"]["user_id"] == message.user_id
    assert data["attributes"]["message_thread_id"] == message.message_thread_id
    assert data["attributes"]["text"] == message.text
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, message_path(conn, :create), %{
      "meta" => %{},
      "data" => %{
        "type" => "message",
        "attributes" => @valid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Message, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, message_path(conn, :create), %{
      "meta" => %{},
      "data" => %{
        "type" => "message",
        "attributes" => @invalid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    message = Repo.insert! %Message{}
    conn = put conn, message_path(conn, :update, message), %{
      "meta" => %{},
      "data" => %{
        "type" => "message",
        "id" => message.id,
        "attributes" => @valid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Message, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    message = Repo.insert! %Message{}
    conn = put conn, message_path(conn, :update, message), %{
      "meta" => %{},
      "data" => %{
        "type" => "message",
        "id" => message.id,
        "attributes" => @invalid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    message = Repo.insert! %Message{}
    conn = delete conn, message_path(conn, :delete, message)
    assert response(conn, 204)
    refute Repo.get(Message, message.id)
  end

end
