defmodule TossBounty.Repo.Migrations.CreateGithubRepos do
  use Ecto.Migration

  def change do
    create table(:github_repos) do
      add :name, :string
    end
  end
end
