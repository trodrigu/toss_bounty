defmodule TossBounty.Repo.Migrations.CreateSkillUser do
  use Ecto.Migration

  def change do
    create table(:skills_users) do
      add :user_id, :integer
      add :skill_id, :integer
      add :details, :text

      timestamps()
    end

  end
end
