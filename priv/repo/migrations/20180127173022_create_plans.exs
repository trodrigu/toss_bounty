defmodule TossBounty.Repo.Migrations.CreatePlans do
  use Ecto.Migration

  def change do
    create table(:plans) do
      add(:uuid, :string)
      add(:user_id, references(:users))
    end
  end
end
