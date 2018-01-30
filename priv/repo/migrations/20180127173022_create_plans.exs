defmodule TossBounty.Repo.Migrations.CreatePlans do
  use Ecto.Migration

  def change do
    create table(:plans) do
      add(:uuid, :string)
      add(:amount, :float)
      add(:interval, :string)
      add(:name, :string)
      add(:currency, :string)
      add(:reward_id, references(:rewards))
    end
  end
end
