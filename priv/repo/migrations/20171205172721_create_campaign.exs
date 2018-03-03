defmodule TossBounty.Repo.Migrations.CreateCampaigns do
  use Ecto.Migration

  # Remember to set the add options for each field.
  # ex: primary_key, default, null, size, precision, scale.
  # Also remember to set the value for on_delete and on_update references options
  # ex: :nothing, :delete_all, :nilify_all, :restrict
  def change do
    create table(:campaigns) do
      add(:short_description, :string)
      add(:long_description, :binary)
      add(:funding_goal, :float)
      add(:current_funding, :float, default: 0.0)
      add(:funding_end_date, :naive_datetime)
      add(:user_id, references(:users, on_delete: :nothing))

      timestamps()
    end

    create(index(:campaigns, [:user_id]))
  end
end
