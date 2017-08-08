defmodule TossBounty.Repo.Migrations.CreateAgreement do
  use Ecto.Migration

  def change do
    create table(:agreements) do
      add :board_id, :integer
      add :details, :text

      timestamps()
    end

  end
end
