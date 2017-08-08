defmodule TossBounty.AgreementSignerControllerTest do
  use TossBounty.ConnCase

  alias TossBounty.AgreementSigner
  alias TossBounty.Repo

  @valid_attrs %{agreement_id: 42, user_id: 42}
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
    conn = get conn, agreement_signer_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    agreement_signer = Repo.insert! %AgreementSigner{}
    conn = get conn, agreement_signer_path(conn, :show, agreement_signer)
    data = json_response(conn, 200)["data"]
    assert data["id"] == "#{agreement_signer.id}"
    assert data["type"] == "agreement-signer"
    assert data["attributes"]["agreement_id"] == agreement_signer.agreement_id
    assert data["attributes"]["user_id"] == agreement_signer.user_id
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, agreement_signer_path(conn, :create), %{
      "meta" => %{},
      "data" => %{
        "type" => "agreement_signer",
        "attributes" => @valid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(AgreementSigner, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, agreement_signer_path(conn, :create), %{
      "meta" => %{},
      "data" => %{
        "type" => "agreement_signer",
        "attributes" => @invalid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    agreement_signer = Repo.insert! %AgreementSigner{}
    conn = put conn, agreement_signer_path(conn, :update, agreement_signer), %{
      "meta" => %{},
      "data" => %{
        "type" => "agreement_signer",
        "id" => agreement_signer.id,
        "attributes" => @valid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(AgreementSigner, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    agreement_signer = Repo.insert! %AgreementSigner{}
    conn = put conn, agreement_signer_path(conn, :update, agreement_signer), %{
      "meta" => %{},
      "data" => %{
        "type" => "agreement_signer",
        "id" => agreement_signer.id,
        "attributes" => @invalid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    agreement_signer = Repo.insert! %AgreementSigner{}
    conn = delete conn, agreement_signer_path(conn, :delete, agreement_signer)
    assert response(conn, 204)
    refute Repo.get(AgreementSigner, agreement_signer.id)
  end

end
