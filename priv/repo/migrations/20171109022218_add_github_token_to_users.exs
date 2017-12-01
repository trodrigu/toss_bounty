defmodule TossBounty.Repo.Migrations.AddGithubTokenToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :github_token, :string
    end
  end
end
