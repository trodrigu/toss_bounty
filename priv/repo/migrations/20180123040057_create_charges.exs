defmodule TossBounty.Repo.Migrations.CreateCharges do
  use Ecto.Migration

  def change do
    create table(:charges) do
      add(:amount, :float)
      add(:message, :string)
    end
  end
end
