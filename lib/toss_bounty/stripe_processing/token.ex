defmodule TossBounty.StripeProcessing.Token do
  use Ecto.Schema
  import Ecto.Changeset
  alias TossBounty.StripeProcessing.Customer
  alias TossBounty.StripeProcessing.Token
  alias TossBounty.Accounts.User

  schema "tokens" do
    field(:uuid, :string)
    belongs_to(:user, User)
    has_many(:customers, Customer)
  end

  @doc false
  def changeset(%Token{} = token, attrs) do
    token
    |> cast(attrs, [:user_id, :uuid])
    |> validate_required([:user_id, :uuid])
    |> assoc_constraint(:user)
  end
end
