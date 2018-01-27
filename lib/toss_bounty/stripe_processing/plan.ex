defmodule TossBounty.StripeProcessing.Plan do
  use Ecto.Schema
  import Ecto.Changeset
  alias TossBounty.Accounts.User
  alias TossBounty.StripeProcessing.Plan

  schema "plans" do
    field(:uuid, :string)
    belongs_to(:user, User)
  end

  @doc false
  def changeset(%Plan{} = plan, attrs) do
    plan
    |> cast(attrs, [:user_id, :uuid])
    |> validate_required([:user_id, :uuid])
    |> assoc_constraint(:user)
  end
end
