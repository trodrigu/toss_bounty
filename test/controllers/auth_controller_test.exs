defmodule TossBounty.AuthControllerTest do
  use TossBounty.ApiCase
  import TossBounty.AuthenticationTestHelpers
  alias TossBounty.User
  alias TossBounty.Repo

  setup do
    conn = build_conn()
    {:ok, conn: conn}
  end

  @valid_attrs %{
    code: "some-code",
    provider: "github"
  }

  describe "callback" do
    test "creates user if one not found", %{conn: conn} do
      conn = get conn, "/auth/github/callback?code=stuff"
      user_count = Repo.one(from u in User, select: count("*"))
      assert user_count == 1
    end
  end
end
