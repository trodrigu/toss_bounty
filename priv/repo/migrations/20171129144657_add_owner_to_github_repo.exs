defmodule TossBounty.Repo.Migrations.AddOwnerToGithubRepo do
  use Ecto.Migration

  def change do
    alter table(:github_repos) do
      add :owner, :string
    end
  end
end
