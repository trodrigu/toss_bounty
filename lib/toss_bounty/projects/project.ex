defmodule TossBountyWeb.Projects.Project do
  use Ecto.Schema
  import Ecto.Changeset
  alias TossBountyWeb.Projects.Project


  schema "projects" do
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
  def changeset(%Project{} = project, attrs) do
    project
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
