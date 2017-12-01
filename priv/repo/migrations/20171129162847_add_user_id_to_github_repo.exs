defmodule TossBounty.Repo.Migrations.AddUserIdToGithubRepo do
  use Ecto.Migration

  def change do
    alter table(:github_repos) do
      add :user_id, references(:users)
    end
  end
end
