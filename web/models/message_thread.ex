defmodule TossBounty.MessageThread do
  use TossBounty.Web, :model

  schema "message_threads" do
    field :board_id, :integer
    field :title, :string
    field :active, :boolean, default: false

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:board_id, :title, :active])
    |> validate_required([:board_id, :title, :active])
  end
end
