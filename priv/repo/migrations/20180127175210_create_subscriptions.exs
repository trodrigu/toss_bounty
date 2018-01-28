defmodule TossBounty.Repo.Migrations.CreateSubscriptions do
  use Ecto.Migration

  def change do
    create table(:subscriptions) do
      add(:uuid, :string)
      add(:customer_id, references(:customers))
      add(:plan_id, references(:plans))
    end
  end
end
