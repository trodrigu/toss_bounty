defmodule TossBounty.TokenControllerTest do
  use TossBounty.ConnCase

  setup config = %{conn: conn} do
    if username = config[:login_as] do
      user = insert_user(username: username, email: "test@test.com")
      conn =
        %{build_conn() | host: "api."}
        |> put_req_header("accept", "application/vnd.api+json")
        |> put_req_header("content-type", "application/vnd.api+json")
        |> assign(:current_user, user)

      {:ok, conn: conn, user: user}
    else
      :ok
    end

  end

  defp create_payload(email, password) do
    %{ "username" => email, "password" => password }
  end

  describe "create" do
    @tag login_as: "max"
    test "authenticates and returns the JWT and user ID when data is valid", %{conn: conn, user: user} do

      conn = post conn, token_path(conn, :create), create_payload(user.email, user.password)
      user_id = user.id
      response = json_response(conn, 201)
      assert response["token"]
      assert response["user_id"] == user_id
    end

    @tag login_as: "max"
    test "does not authenticate and renders errors when the email and password are missing", %{conn: conn, user: _user} do
      conn = post conn, token_path(conn, :create), %{"username" => ""}

      response = json_response(conn, 401)
      [error | _] = response["errors"]
      assert error["detail"] == "Please enter your email and password."
      refute response["token"]
      refute response["user_id"]
    end

    @tag login_as: "max"
    test "does not authenticate and renders errors when only the password is missing", %{conn: conn, user: _user} do
      conn = post conn, token_path(conn, :create), %{"username" => "test@email.com"}
      response = json_response(conn, 401)
      [error | _] = response["errors"]
      assert error["detail"] == "Please enter your password."
      assert renders_401_unauthorized?(error)
      refute response["token"]
      refute response["user_id"]
    end

    @tag login_as: "max"
    test "does not authenticate and renders errors when the password is wrong", %{conn: conn, user: user} do
      conn = post conn, token_path(conn, :create), create_payload(user.email, "wrong password")
      response = json_response(conn, 401)
      [error | _] = response["errors"]
      assert renders_401_unauthorized?(error)
      refute response["token"]
      refute response["user_id"]
    end

    @tag login_as: "max"
    test "does not authenticate and renders errors when the user does not exist", %{conn: conn, user: _user} do
      conn = post conn, token_path(conn, :create), create_payload("invalid_user@test.com", "password")
      response = json_response(conn, 401)
      [error | _] = response["errors"]
      assert error["detail"] == "We couldn't find a user with the email invalid_user@test.com."
      refute response["token"]
      refute response["user_id"]
    end
  end

  describe "refresh" do
    @tag login_as: "max"
    test "refreshes JWT and returns JWT and user ID when data is valid", %{conn: conn, user: user} do
      {:ok, token, _claims} = user |> Guardian.encode_and_sign(:token)
      conn = post conn, token_path(conn, :refresh), %{token: token}

      response = json_response(conn, 201)
      assert response["token"]
      assert response["user_id"] == user.id
    end

    @tag login_as: "max"
    test "does not authenticate and renders errors when the token is expired", %{conn: conn, user: user} do
      {:ok, token, _claims} = user |> Guardian.encode_and_sign(:token, %{ "exp" => Guardian.Utils.timestamp - 10})
      conn = post conn, token_path(conn, :refresh), %{token: token}

      response = json_response(conn, 401)
      refute response["token"]
      refute response["user_id"]
      [error | _] = response["errors"]
      assert renders_401_unauthorized?(error)
      assert error["detail"] == "token_expired"
    end
  end

  defp renders_401_unauthorized?(%{"id" => "UNAUTHORIZED", "title" => "401 Unauthorized", "status" => 401}), do: true
  defp renders_401_unauthorized?(_), do: false
end
