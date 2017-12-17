defmodule TossBounty.Repo.Migrations.AddImageToGithubRepo do
  use Ecto.Migration

  def change do
    alter table(:github_repos) do
      add :image, :string
    end
  end
end
