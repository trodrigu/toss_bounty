defmodule TossBounty.Repo.Migrations.AddGithubRepoReferenceToCampaign do
  use Ecto.Migration

  def change do
    alter table(:campaigns) do
      add :github_repo_id, references(:github_repos)
    end
  end
end
