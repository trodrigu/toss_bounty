defmodule TossBounty.TestHelpers do
  alias TossBounty.Repo

  def insert_user(attrs \\ %{}) do
    changes = Dict.merge(%{ name: "Some User",
                            username: "user#{Base.encode16(:crypto.rand_bytes(8))}",
                            email: "test@test.com",
                            password: "supersecret"},
      attrs)

    %TossBounty.User{}
    |> TossBounty.User.registration_changeset(changes)
    |> Repo.insert!()
  end
end
