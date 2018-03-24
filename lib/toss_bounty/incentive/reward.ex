defmodule TossBounty.Incentive.Reward do
  use Ecto.Schema
  import Ecto.Changeset
  alias TossBounty.Incentive.Reward

  schema "rewards" do
    field(:description, :string)
    field(:donation_level, :float)
    belongs_to(:campaign, TossBounty.Campaigns.Campaign)
    has_one(:plan, TossBounty.StripeProcessing.Plan, on_delete: :delete_all)

    timestamps()
  end

  @doc false
  def changeset(%Reward{} = reward, attrs) do
    reward
    |> cast(attrs, [
      :description,
      :donation_level,
      :campaign_id
    ])
    |> validate_required([
      :description,
      :donation_level,
      :campaign_id
    ])
  end
end
