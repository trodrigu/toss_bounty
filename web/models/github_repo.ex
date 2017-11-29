defmodule TossBounty.GitHubRepo do
  use TossBounty.Web, :model

  schema "github_repos" do
    field :name, :string
  end

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, [:name])
  end
end
