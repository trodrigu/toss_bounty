defmodule TossBounty.StripeProcessing.Charge do
  use Ecto.Schema
  import Ecto.Changeset
  alias TossBounty.StripeProcessing.Charge
  alias TossBounty.Accounts.User

  schema "charges" do
    field(:token, :string)
    field(:amount, :float)
    field(:successful, :boolean)
    field(:message, :string)
    belongs_to(:maintainer, User)
    belongs_to(:contributor, User)
  end

  @doc false
  def changeset(%Charge{} = charge, attrs) do
    charge
    |> cast(attrs, [:token, :amount, :successful, :message, :maintainer_id, :contributor_id])
    |> validate_required([:token, :amount, :successful, :message, :maintainer_id, :contributor_id])
    |> assoc_constraint(:maintainer)
    |> assoc_constraint(:contributor)
  end
end
