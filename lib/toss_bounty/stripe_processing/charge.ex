defmodule TossBounty.StripeProcessing.Charge do
  use Ecto.Schema
  import Ecto.Changeset
  alias TossBounty.StripeProcessing.Charge

  schema "charges" do
    field(:token, :string)
  end

  @doc false
  def changeset(%Charge{} = charge, attrs) do
    charge
    |> cast(attrs, [:token])
    |> validate_required([:token])
  end
end
