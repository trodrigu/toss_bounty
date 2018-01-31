defmodule TossBounty.StripeProcessing.Subscription do
  use Ecto.Schema
  import Ecto.Changeset
  alias TossBounty.Accounts.User
  alias TossBounty.StripeProcessing.Subscription
  alias TossBounty.StripeProcessing.Customer
  alias TossBounty.StripeProcessing.Plan

  schema "subscriptions" do
    field(:uuid, :string)
    belongs_to(:customer, Customer)
    belongs_to(:plan, Plan)
  end

  @doc false
  def changeset(%Subscription{} = subscription, attrs) do
    subscription
    |> cast(attrs, [:plan_id, :customer_id, :uuid])
    |> validate_required([:plan_id, :customer_id, :uuid])
    |> assoc_constraint(:customer)
    |> assoc_constraint(:plan)
  end
end
