defmodule TossBounty.Incentive.Reward do
  use Ecto.Schema
  import Ecto.Changeset
  alias TossBounty.Incentive.Reward


  schema "rewards" do
    field :description, :string
    field :donation_level, :float

    timestamps()
  end

  @doc false
  def changeset(%Reward{} = reward, attrs) do
    reward
    |> cast(attrs, [
      :description,
      :donation_level,
      
    ])
    |> validate_required([
      :description,
      :donation_level,
      
    ])
  end
end
