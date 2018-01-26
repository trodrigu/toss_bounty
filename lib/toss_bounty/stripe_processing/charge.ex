defmodule TossBounty.StripeProcessing.Charge do
  use Ecto.Schema
  import Ecto.Changeset
  alias TossBounty.StripeProcessing.Charge
  alias TossBounty.Accounts.User
  alias TossBounty.StripeProcessing.Token

  schema "charges" do
    field(:amount, :float)
    field(:message, :string)
    belongs_to(:token, Token)
  end

  @doc false
  def changeset(%Charge{} = charge, attrs) do
    charge
    |> cast(attrs, [:token_id, :amount, :message])
    |> validate_required([:token_id, :amount, :message])
    |> assoc_constraint(:token)
  end
end
