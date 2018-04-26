defmodule TossBounty.Repo.Migrations.RemoveTheFundingEndDate do
  use Ecto.Migration

  def change do
    alter table(:campaigns) do
      remove :funding_end_date
    end
  end
end
