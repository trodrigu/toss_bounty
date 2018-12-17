defmodule TossBountyWeb.TokenController do
  use TossBountyWeb.Web, :controller
  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]
  alias TossBounty.GuardianSerializer
  alias TossBounty.Repo
  alias TossBounty.Accounts.User
  alias TossBounty.UserManager.Guardian

  def create(conn, params = %{"email" => _, "password" => _}) do
    case login_by_email_and_password(params) do
      {:ok, user} ->
        {:ok, token, _claims} =
          user
          |> TossBounty.UserManager.Guardian.encode_and_sign()

        conn
        |> Plug.Conn.assign(:current_user, user)
        |> put_status(:created)
        |> render("show.json", token: token, user_id: user.id)

      {:error, reason} ->
        handle_unauthenticated(conn, reason)
    end
  end

  def create(conn, %{"email" => ""}) do
    handle_unauthenticated(conn, "Please enter your email and password.")
  end

  def create(conn, _) do
    handle_unauthenticated(conn, "Please enter your password.")
  end

  def refresh(conn, %{"token" => current_token}) do
    with {:ok, claims} <- TossBounty.UserManager.Guardian.decode_and_verify(current_token),
         {:ok, _old_stuff, {new_token, new_claims}} <-
           TossBounty.UserManager.Guardian.refresh(current_token),
         {:ok, user, _claims} <-
           TossBounty.UserManager.Guardian.resource_from_token(current_token) do
      conn
      |> Plug.Conn.assign(:current_user, user)
      |> put_status(:created)
      |> render("show.json", token: new_token, user_id: user.id)
    else
      {:error, reason} -> handle_unauthenticated(conn, reason)
    end
  end

  defp handle_unauthenticated(conn, reason) do
    conn
    |> put_status(:unauthorized)
    |> render("401.json", message: reason)
  end

  defp login_by_email_and_password(%{"email" => email, "password" => password}) do
    user = Repo.get_by(User, email: email)

    cond do
      user && checkpw(password, user.password_hash) ->
        {:ok, user}

      user ->
        {:error, "Your password doesn't match the email #{email}."}

      true ->
        dummy_checkpw()
        {:error, "We couldn't find a user with the email #{email}."}
    end
  end
end
