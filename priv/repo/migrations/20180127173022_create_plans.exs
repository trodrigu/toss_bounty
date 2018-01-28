defmodule TossBounty.Repo.Migrations.CreatePlans do
  use Ecto.Migration

  def change do
    create table(:plans) do
      add(:uuid, :string)
      add(:customer_id, references(:customers))
    end
  end
end
