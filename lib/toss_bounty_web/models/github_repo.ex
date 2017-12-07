defmodule TossBountyWeb.GitHubRepo do
  use TossBountyWeb.Web, :model
  alias TossBountyWeb.User
  alias TossBountyWeb.GitHubIssue

  schema "github_repos" do
    field :name, :string
    field :owner, :string
    belongs_to :user, User
    has_many :github_issues, GitHubIssue
  end

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, [:name, :owner, :user_id])
    |> assoc_constraint(:user)
  end
end