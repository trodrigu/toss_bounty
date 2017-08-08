defmodule TossBounty.Repo.Migrations.CreateSkill do
  use Ecto.Migration

  def change do
    create table(:skills) do
      add :name, :string

      timestamps()
    end

  end
end
