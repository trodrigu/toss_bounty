defmodule TossBounty.Repo.Migrations.CreateRewards do
  use Ecto.Migration


  # Remember to set the add options for each field.
  # ex: primary_key, default, null, size, precision, scale.
  # Also remember to set the value for on_delete and on_update references options
  # ex: :nothing, :delete_all, :nilify_all, :restrict
  def change do
    create table(:rewards) do
      add :description, :string
      add :donation_level, :float
      add :campaign_id, references(:campaigns)

      timestamps()
    end

  end
end
