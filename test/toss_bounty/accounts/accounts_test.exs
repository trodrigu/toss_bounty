defmodule TossBounty.AccountsTest do
  use TossBountyWeb.DataCase

  alias TossBounty.Accounts
  alias TossBounty.Accounts.User

  setup do
    user = with {:ok, user} <- Repo.insert!(%User{email: "test@test.com"}), do: user
    {:ok, user: user}
  end
  @update_attrs %{
    stripe_external_id: "an-external-id",
    stripe_access_token: "an-access-token"
  }
  test "update_user/2 with valid data updates the user", %{user: user} do
    assert {:ok, user} = Accounts.update_user(user, @update_attrs)
    assert %User{} = user
    assert user.stripe_external_id == "an-external-id"
    assert user.stripe_access_token == "an-access-token"
  end
end
