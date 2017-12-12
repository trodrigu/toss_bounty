defmodule TossBounty.Repo.Migrations.ConvertFundingEndDateToDatetimeWithTz do
  use Ecto.Migration

  def change do
    execute """
    CREATE TYPE datetimetz AS (
    dt timestamptz,
    tz varchar
    );
    """
    alter table(:campaigns) do
      remove :funding_end_date
      add :funding_end_date, :datetimetz
    end
  end
end
