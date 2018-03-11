defmodule TossBounty.StripeProcessing.Customer do
  use Ecto.Schema
  import Ecto.Changeset
  alias TossBounty.Accounts.User
  alias TossBounty.StripeProcessing.Customer
  alias TossBounty.Campaigns.Campaign
  alias TossBounty.StripeProcessing.Token
  alias TossBounty.StripeProcessing.Subscription

  schema "customers" do
    field(:uuid, :string)
    belongs_to(:token, Token)
    belongs_to(:campaign, Campaign)
    has_one(:subscription, Subscription)
  end

  @doc false
  def changeset(%Customer{} = customer, attrs) do
    customer
    |> cast(attrs, [:token_id, :uuid, :campaign_id])
    |> validate_required([:uuid])
    |> assoc_constraint(:token)
    |> assoc_constraint(:campaign)
  end
end
