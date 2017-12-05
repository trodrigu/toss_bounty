defmodule TossBounty.Repo.Migrations.CreateProjects do
  use Ecto.Migration


  # Remember to set the add options for each field.
  # ex: primary_key, default, null, size, precision, scale.
  # Also remember to set the value for on_delete and on_update references options 
  # ex: :nothing, :delete_all, :nilify_all, :restrict
  def change do
    create table(:projects) do
      add :short_description, :string
      add :long_description, :binary
      add :funding_goal, :float
      add :current_funding, :float
      add :funding_end_date, :naive_datetime
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:projects, [:user_id])
  end
end
