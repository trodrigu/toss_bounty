defmodule TossBountyWeb.Campaigns.Campaign do
  use Ecto.Schema
  import Ecto.Changeset
  alias TossBountyWeb.Campaigns.Campaign


  schema "campaigns" do
    field :current_funding, :float
    field :funding_end_date, :naive_datetime
    field :funding_goal, :float
    field :long_description, :binary
    field :short_description, :string
    belongs_to :user, TossBountyWeb.User
    # field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(%Campaign{} = campaign, attrs) do
    campaign
    |> cast(attrs, [
      :short_description,
      :long_description,
      :funding_goal,
      :current_funding,
      :funding_end_date,
      :user_id,

    ])
    |> validate_required([
      :short_description,
      :long_description,
      :funding_goal,
      :current_funding,
      :funding_end_date,
      :user_id,

    ])
  end
end
