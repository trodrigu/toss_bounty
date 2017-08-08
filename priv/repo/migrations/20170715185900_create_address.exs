defmodule TossBounty.Repo.Migrations.CreateAddress do
  use Ecto.Migration

  def change do
    create table(:addresses) do
      add :street_address, :string
      add :street_address_2, :string
      add :city, :string
      add :state, :string
      add :zip, :string
      add :user_id, :integer
      add :latitude, :float
      add :longitude, :float

      timestamps()
    end

  end
end
