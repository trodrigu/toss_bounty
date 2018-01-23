defmodule TossBounty.Repo.Migrations.CreateCharges do
  use Ecto.Migration

  def change do
    create table(:charges) do
      add(:token, :string)
      add(:amount, :float)
      add(:successful, :bool)
      add(:message, :string)
      add(:maintainer_id, references(:users))
      add(:contributor_id, references(:users))
    end
  end
end
