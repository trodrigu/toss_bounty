defmodule TossBounty.SkillUser do
  use TossBounty.Web, :model

  schema "skills_users" do
    field :user_id, :integer
    field :skill_id, :integer
    field :details, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:user_id, :skill_id, :details])
    |> validate_required([:user_id, :skill_id, :details])
  end
end
