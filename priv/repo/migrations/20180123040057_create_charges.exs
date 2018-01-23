defmodule TossBounty.Repo.Migrations.CreateCharges do
  use Ecto.Migration

  def change do
    create table(:charges) do
      add(:token, :string)
    end
  end
end
