defmodule TossBounty.Message do
  use TossBounty.Web, :model

  schema "messages" do
    field :user_id, :integer
    field :message_thread_id, :integer
    field :text, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:user_id, :message_thread_id, :text])
    |> validate_required([:user_id, :message_thread_id, :text])
  end
end
