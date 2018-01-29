defmodule TossBounty.StripeProcessing.Plan do
  use Ecto.Schema
  import Ecto.Changeset
  alias TossBounty.Accounts.User
  alias TossBounty.StripeProcessing.Plan
  alias TossBounty.StripeProcessing.Subscription

  schema "plans" do
    field(:uuid, :string)
    field(:amount, :float)
    field(:interval, :string)
    field(:name, :string)
    field(:currency, :string)
    has_many(:subscription, Subscription)
  end

  @doc false
  def changeset(%Plan{} = plan, attrs) do
    plan
    |> cast(attrs, [:uuid, :amount, :interval, :name, :currency])
    |> validate_required([:uuid, :amount, :interval, :name, :currency])
  end
end
