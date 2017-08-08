defmodule TossBounty.SkillUserControllerTest do
  use TossBounty.ConnCase

  alias TossBounty.SkillUser
  alias TossBounty.Repo

  @valid_attrs %{details: "some content", skill_id: 42, user_id: 42}
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
    conn = get conn, skill_user_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    skill_user = Repo.insert! %SkillUser{}
    conn = get conn, skill_user_path(conn, :show, skill_user)
    data = json_response(conn, 200)["data"]
    assert data["id"] == "#{skill_user.id}"
    assert data["type"] == "skill-user"
    assert data["attributes"]["user_id"] == skill_user.user_id
    assert data["attributes"]["skill_id"] == skill_user.skill_id
    assert data["attributes"]["details"] == skill_user.details
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, skill_user_path(conn, :create), %{
      "meta" => %{},
      "data" => %{
        "type" => "skill_user",
        "attributes" => @valid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(SkillUser, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, skill_user_path(conn, :create), %{
      "meta" => %{},
      "data" => %{
        "type" => "skill_user",
        "attributes" => @invalid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    skill_user = Repo.insert! %SkillUser{}
    conn = put conn, skill_user_path(conn, :update, skill_user), %{
      "meta" => %{},
      "data" => %{
        "type" => "skill_user",
        "id" => skill_user.id,
        "attributes" => @valid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(SkillUser, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    skill_user = Repo.insert! %SkillUser{}
    conn = put conn, skill_user_path(conn, :update, skill_user), %{
      "meta" => %{},
      "data" => %{
        "type" => "skill_user",
        "id" => skill_user.id,
        "attributes" => @invalid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    skill_user = Repo.insert! %SkillUser{}
    conn = delete conn, skill_user_path(conn, :delete, skill_user)
    assert response(conn, 204)
    refute Repo.get(SkillUser, skill_user.id)
  end

end
