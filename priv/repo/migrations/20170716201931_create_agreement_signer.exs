defmodule TossBounty.Repo.Migrations.CreateAgreementSigner do
  use Ecto.Migration

  def change do
    create table(:agreement_signers) do
      add :agreement_id, :integer
      add :user_id, :integer

      timestamps()
    end

  end
end
