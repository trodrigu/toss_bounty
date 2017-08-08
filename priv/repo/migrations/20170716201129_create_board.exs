defmodule TossBounty.Repo.Migrations.CreateBoard do
  use Ecto.Migration

  def change do
    create table(:boards) do
      add :user_id, :integer
      add :skill_needed, :integer
      add :skill_offered, :integer
      add :status, :string
      add :needed_by, :date
      add :longitude, :float
      add :latitude, :float

      timestamps()
    end

  end
end
