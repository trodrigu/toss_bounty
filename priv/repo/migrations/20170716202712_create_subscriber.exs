defmodule TossBounty.Repo.Migrations.CreateSubscriber do
  use Ecto.Migration

  def change do
    create table(:subscribers) do
      add :user_id, :integer
      add :message_thread_id, :integer
      add :active, :boolean, default: false, null: false

      timestamps()
    end

  end
end
