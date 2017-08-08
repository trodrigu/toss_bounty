defmodule TossBounty.ContactInfo do
  use TossBounty.Web, :model

  schema "contact_infos" do
    field :full_name, :string
    field :phone, :string
    field :website, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:full_name, :phone, :website])
    |> validate_required([:full_name, :phone, :website])
  end
end
