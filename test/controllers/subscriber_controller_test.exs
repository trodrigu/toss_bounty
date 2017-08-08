defmodule TossBounty.SubscriberControllerTest do
  use TossBounty.ConnCase

  alias TossBounty.Subscriber
  alias TossBounty.Repo

  @valid_attrs %{active: true, message_thread_id: 42, user_id: 42}
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
    conn = get conn, subscriber_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    subscriber = Repo.insert! %Subscriber{}
    conn = get conn, subscriber_path(conn, :show, subscriber)
    data = json_response(conn, 200)["data"]
    assert data["id"] == "#{subscriber.id}"
    assert data["type"] == "subscriber"
    assert data["attributes"]["user_id"] == subscriber.user_id
    assert data["attributes"]["message_thread_id"] == subscriber.message_thread_id
    assert data["attributes"]["active"] == subscriber.active
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, subscriber_path(conn, :create), %{
      "meta" => %{},
      "data" => %{
        "type" => "subscriber",
        "attributes" => @valid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Subscriber, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, subscriber_path(conn, :create), %{
      "meta" => %{},
      "data" => %{
        "type" => "subscriber",
        "attributes" => @invalid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    subscriber = Repo.insert! %Subscriber{}
    conn = put conn, subscriber_path(conn, :update, subscriber), %{
      "meta" => %{},
      "data" => %{
        "type" => "subscriber",
        "id" => subscriber.id,
        "attributes" => @valid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Subscriber, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    subscriber = Repo.insert! %Subscriber{}
    conn = put conn, subscriber_path(conn, :update, subscriber), %{
      "meta" => %{},
      "data" => %{
        "type" => "subscriber",
        "id" => subscriber.id,
        "attributes" => @invalid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    subscriber = Repo.insert! %Subscriber{}
    conn = delete conn, subscriber_path(conn, :delete, subscriber)
    assert response(conn, 204)
    refute Repo.get(Subscriber, subscriber.id)
  end

end
