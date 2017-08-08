defmodule TossBounty.Address do
  use TossBounty.Web, :model

  schema "addresses" do
    field :street_address, :string
    field :street_address_2, :string
    field :city, :string
    field :state, :string
    field :zip, :string
    field :user_id, :integer
    field :latitude, :float
    field :longitude, :float

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:street_address, :street_address_2, :city, :state, :zip, :user_id, :latitude, :longitude])
    |> validate_required([:street_address, :street_address_2, :city, :state, :zip, :user_id, :latitude, :longitude])
  end
end
