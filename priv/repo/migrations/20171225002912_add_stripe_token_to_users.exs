defmodule TossBounty.Repo.Migrations.AddStripeTokenToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :stripe_token, :string
    end
  end
end
