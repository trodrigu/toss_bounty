defmodule TossBounty.StripeProcessing.Customer do
  use Ecto.Schema
  import Ecto.Changeset
  alias TossBounty.Accounts.User
  alias TossBounty.StripeProcessing.Customer
  alias TossBounty.StripeProcessing.Token
  alias TossBounty.StripeProcessing.Subscription

  schema "customers" do
    field(:uuid, :string)
    belongs_to(:token, Token)
    has_one(:subscription, Subscription)
  end

  @doc false
  def changeset(%Customer{} = customer, attrs) do
    customer
    |> cast(attrs, [:token_id, :uuid])
    |> validate_required([:token_id, :uuid])
    |> assoc_constraint(:token)
  end
end
