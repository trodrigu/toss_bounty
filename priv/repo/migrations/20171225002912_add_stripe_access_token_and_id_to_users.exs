defmodule TossBounty.Repo.Migrations.AddStripeAccessTokenAndIdToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :stripe_access_token, :string
      add :stripe_external_id, :string
    end
  end
end
