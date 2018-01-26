defmodule TossBounty.Repo.Migrations.CreateTokens do
  use Ecto.Migration

  def change do
    create table(:tokens) do
      add(:uuid, :string)
      add(:user_id, references(:users))
    end

    alter table(:charges) do
      add(:token_id, references(:tokens))
    end
  end
end
