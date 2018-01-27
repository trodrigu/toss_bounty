defmodule TossBounty.Repo.Migrations.CreateSubscriptions do
  use Ecto.Migration

  def change do
    create table(:subscriptions) do
      add(:uuid, :string)
      add(:user_id, references(:users))
    end
  end
end
