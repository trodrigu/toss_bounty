defmodule TossBounty.Board do
  use TossBounty.Web, :model

  schema "boards" do
    field :user_id, :integer
    field :skill_needed, :integer
    field :skill_offered, :integer
    field :status, :string
    field :needed_by, Ecto.Date
    field :longitude, :float
    field :latitude, :float

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:user_id, :skill_needed, :skill_offered, :status, :needed_by, :longitude, :latitude])
    |> validate_required([:user_id, :skill_needed, :skill_offered, :status, :needed_by, :longitude, :latitude])
  end
end
