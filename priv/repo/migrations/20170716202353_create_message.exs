defmodule TossBounty.Repo.Migrations.CreateMessage do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :user_id, :integer
      add :message_thread_id, :integer
      add :text, :text

      timestamps()
    end

  end
end
