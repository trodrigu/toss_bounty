defmodule TossBounty.AgreementSigner do
  use TossBounty.Web, :model

  schema "agreement_signers" do
    field :agreement_id, :integer
    field :user_id, :integer

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:agreement_id, :user_id])
    |> validate_required([:agreement_id, :user_id])
  end
end
