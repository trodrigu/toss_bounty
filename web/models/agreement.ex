defmodule TossBounty.Agreement do
  use TossBounty.Web, :model

  schema "agreements" do
    field :board_id, :integer
    field :details, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:board_id, :details])
    |> validate_required([:board_id, :details])
  end
end
