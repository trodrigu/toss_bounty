defmodule TossBounty.StripeProcessing.Plan do
  use Ecto.Schema
  import Ecto.Changeset
  alias TossBounty.Accounts.User
  alias TossBounty.StripeProcessing.Plan
  alias TossBounty.StripeProcessing.Subscription

  schema "plans" do
    field(:uuid, :string)
    has_one(:subscription, Subscription)
  end

  @doc false
  def changeset(%Plan{} = plan, attrs) do
    plan
    |> cast(attrs, [:uuid])
    |> validate_required([:uuid])
  end
end
