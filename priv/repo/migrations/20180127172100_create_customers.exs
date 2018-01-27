defmodule TossBounty.Repo.Migrations.CreateCustomers do
  use Ecto.Migration

  def change do
    create table(:customers) do
      add(:uuid, :string)
      add(:user_id, references(:users))
    end
  end
end
