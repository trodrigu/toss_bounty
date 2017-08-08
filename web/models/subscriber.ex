defmodule TossBounty.Subscriber do
  use TossBounty.Web, :model

  schema "subscribers" do
    field :user_id, :integer
    field :message_thread_id, :integer
    field :active, :boolean, default: false

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:user_id, :message_thread_id, :active])
    |> validate_required([:user_id, :message_thread_id, :active])
  end
end
