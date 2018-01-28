defmodule TossBounty.StripeProcessing.Plan do
  use Ecto.Schema
  import Ecto.Changeset
  alias TossBounty.Accounts.User
  alias TossBounty.StripeProcessing.Plan

  schema "plans" do
    field(:uuid, :string)
    belongs_to(:customer, Customer)
  end

  @doc false
  def changeset(%Plan{} = plan, attrs) do
    plan
    |> cast(attrs, [:customer_id, :uuid])
    |> validate_required([:customer_id, :uuid])
    |> assoc_constraint(:customer)
  end
end
