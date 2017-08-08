defmodule TossBounty.SkillControllerTest do
  use TossBounty.ConnCase

  alias TossBounty.Skill
  alias TossBounty.Repo

  @valid_attrs %{name: "some content"}
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
    conn = get conn, skill_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    skill = Repo.insert! %Skill{}
    conn = get conn, skill_path(conn, :show, skill)
    data = json_response(conn, 200)["data"]
    assert data["id"] == "#{skill.id}"
    assert data["type"] == "skill"
    assert data["attributes"]["name"] == skill.name
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, skill_path(conn, :create), %{
      "meta" => %{},
      "data" => %{
        "type" => "skill",
        "attributes" => @valid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Skill, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, skill_path(conn, :create), %{
      "meta" => %{},
      "data" => %{
        "type" => "skill",
        "attributes" => @invalid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    skill = Repo.insert! %Skill{}
    conn = put conn, skill_path(conn, :update, skill), %{
      "meta" => %{},
      "data" => %{
        "type" => "skill",
        "id" => skill.id,
        "attributes" => @valid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Skill, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    skill = Repo.insert! %Skill{}
    conn = put conn, skill_path(conn, :update, skill), %{
      "meta" => %{},
      "data" => %{
        "type" => "skill",
        "id" => skill.id,
        "attributes" => @invalid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    skill = Repo.insert! %Skill{}
    conn = delete conn, skill_path(conn, :delete, skill)
    assert response(conn, 204)
    refute Repo.get(Skill, skill.id)
  end

end
