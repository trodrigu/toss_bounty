defmodule TossBounty.Repo.Migrations.CreateMessageThread do
  use Ecto.Migration

  def change do
    create table(:message_threads) do
      add :board_id, :integer
      add :title, :string
      add :active, :boolean, default: false, null: false

      timestamps()
    end

  end
end
