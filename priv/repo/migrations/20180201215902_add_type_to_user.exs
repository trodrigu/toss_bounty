defmodule TossBounty.Repo.Migrations.AddTypeToUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add(:type, :integer)
    end
  end
end
