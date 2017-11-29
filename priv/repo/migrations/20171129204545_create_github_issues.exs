defmodule TossBounty.Repo.Migrations.CreateGithubIssues do
  use Ecto.Migration

  def change do
    create table(:github_issues) do
      add :title, :string
      add :body, :text
      add :github_repo_id, references(:github_repos)
    end
  end
end
