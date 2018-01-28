defmodule TossBounty.Repo.Migrations.CreateCustomers do
  use Ecto.Migration

  def change do
    create table(:customers) do
      add(:uuid, :string)
      add(:token_id, references(:tokens))
    end
  end
end
