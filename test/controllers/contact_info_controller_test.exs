defmodule TossBounty.ContactInfoControllerTest do
  use TossBounty.ConnCase

  alias TossBounty.ContactInfo
  alias TossBounty.Repo

  @valid_attrs %{full_name: "some content", phone: "some content", website: "some content"}
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
    conn = get conn, contact_info_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    contact_info = Repo.insert! %ContactInfo{}
    conn = get conn, contact_info_path(conn, :show, contact_info)
    data = json_response(conn, 200)["data"]
    assert data["id"] == "#{contact_info.id}"
    assert data["type"] == "contact-info"
    assert data["attributes"]["full_name"] == contact_info.full_name
    assert data["attributes"]["phone"] == contact_info.phone
    assert data["attributes"]["website"] == contact_info.website
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, contact_info_path(conn, :create), %{
      "meta" => %{},
      "data" => %{
        "type" => "contact_info",
        "attributes" => @valid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(ContactInfo, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, contact_info_path(conn, :create), %{
      "meta" => %{},
      "data" => %{
        "type" => "contact_info",
        "attributes" => @invalid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    contact_info = Repo.insert! %ContactInfo{}
    conn = put conn, contact_info_path(conn, :update, contact_info), %{
      "meta" => %{},
      "data" => %{
        "type" => "contact_info",
        "id" => contact_info.id,
        "attributes" => @valid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(ContactInfo, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    contact_info = Repo.insert! %ContactInfo{}
    conn = put conn, contact_info_path(conn, :update, contact_info), %{
      "meta" => %{},
      "data" => %{
        "type" => "contact_info",
        "id" => contact_info.id,
        "attributes" => @invalid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    contact_info = Repo.insert! %ContactInfo{}
    conn = delete conn, contact_info_path(conn, :delete, contact_info)
    assert response(conn, 204)
    refute Repo.get(ContactInfo, contact_info.id)
  end

end
