defmodule TossBounty.AddressControllerTest do
  use TossBounty.ConnCase

  alias TossBounty.Address
  alias TossBounty.Repo

  @valid_attrs %{city: "some content", latitude: "120.5", longitude: "120.5", state: "some content", street_address: "some content", street_address_2: "some content", user_id: 42, zip: "some content"}
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
    conn = get conn, address_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    address = Repo.insert! %Address{}
    conn = get conn, address_path(conn, :show, address)
    data = json_response(conn, 200)["data"]
    assert data["id"] == "#{address.id}"
    assert data["type"] == "address"
    assert data["attributes"]["street_address"] == address.street_address
    assert data["attributes"]["street_address_2"] == address.street_address_2
    assert data["attributes"]["city"] == address.city
    assert data["attributes"]["state"] == address.state
    assert data["attributes"]["zip"] == address.zip
    assert data["attributes"]["user_id"] == address.user_id
    assert data["attributes"]["latitude"] == address.latitude
    assert data["attributes"]["longitude"] == address.longitude
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, address_path(conn, :create), %{
      "meta" => %{},
      "data" => %{
        "type" => "address",
        "attributes" => @valid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Address, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, address_path(conn, :create), %{
      "meta" => %{},
      "data" => %{
        "type" => "address",
        "attributes" => @invalid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    address = Repo.insert! %Address{}
    conn = put conn, address_path(conn, :update, address), %{
      "meta" => %{},
      "data" => %{
        "type" => "address",
        "id" => address.id,
        "attributes" => @valid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Address, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    address = Repo.insert! %Address{}
    conn = put conn, address_path(conn, :update, address), %{
      "meta" => %{},
      "data" => %{
        "type" => "address",
        "id" => address.id,
        "attributes" => @invalid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    address = Repo.insert! %Address{}
    conn = delete conn, address_path(conn, :delete, address)
    assert response(conn, 204)
    refute Repo.get(Address, address.id)
  end

end
