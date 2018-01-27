defmodule TossBounty.StripeProcessing.Subscription do
  use Ecto.Schema
  import Ecto.Changeset
  alias TossBounty.Accounts.User
  alias TossBounty.StripeProcessing.Subscription

  schema "subscriptions" do
    field(:uuid, :string)
    belongs_to(:user, User)
  end

  @doc false
  def changeset(%Subscription{} = subscription, attrs) do
    subscription
    |> cast(attrs, [:user_id, :uuid])
    |> validate_required([:user_id, :uuid])
    |> assoc_constraint(:user)
  end
end
