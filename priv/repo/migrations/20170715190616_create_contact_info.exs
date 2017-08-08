defmodule TossBounty.Repo.Migrations.CreateContactInfo do
  use Ecto.Migration

  def change do
    create table(:contact_infos) do
      add :full_name, :string
      add :phone, :string
      add :website, :string

      timestamps()
    end

  end
end
