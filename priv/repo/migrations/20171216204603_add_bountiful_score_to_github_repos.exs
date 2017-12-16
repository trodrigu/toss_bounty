defmodule TossBounty.Repo.Migrations.AddBountifulScoreToGithubRepos do
  use Ecto.Migration

  def change do
    alter table(:github_repos) do
      add :bountiful_score, :integer
    end
  end
end
