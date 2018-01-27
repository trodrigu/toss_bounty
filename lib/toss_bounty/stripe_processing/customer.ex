defmodule TossBounty.StripeProcessing.Customer do
  use Ecto.Schema
  import Ecto.Changeset
  alias TossBounty.Accounts.User
  alias TossBounty.StripeProcessing.Customer

  schema "customers" do
    field(:uuid, :string)
    belongs_to(:user, User)
  end

  @doc false
  def changeset(%Customer{} = customer, attrs) do
    customer
    |> cast(attrs, [:user_id, :uuid])
    |> validate_required([:user_id, :uuid])
    |> assoc_constraint(:user)
  end
end
