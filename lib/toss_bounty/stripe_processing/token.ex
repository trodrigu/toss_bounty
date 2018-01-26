defmodule TossBounty.StripeProcessing.Token do
  use Ecto.Schema
  import Ecto.Changeset
  alias TossBounty.StripeProcessing.Charge
  alias TossBounty.StripeProcessing.Token
  alias TossBounty.Accounts.User

  schema "tokens" do
    field(:uuid, :string)
    belongs_to(:user, User)
  end

  @doc false
  def changeset(%Token{} = token, attrs) do
    token
    |> cast(attrs, [:user_id, :uuid])
    |> validate_required([:user_id, :uuid])
    |> assoc_constraint(:user)
  end
end
