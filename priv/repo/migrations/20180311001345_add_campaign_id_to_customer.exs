defmodule TossBounty.Repo.Migrations.AddCampaignIdToCustomer do
  use Ecto.Migration

  def change do
    alter table(:customers) do
      add(:campaign_id, references(:campaigns))
    end
  end
end
