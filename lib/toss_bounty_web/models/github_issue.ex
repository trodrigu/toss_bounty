defmodule TossBountyWeb.GitHubIssue do
  use TossBountyWeb.Web, :model
  alias TossBountyWeb.GitHubRepo

  schema "github_issues" do
    field :title, :string
    field :body, :binary
    belongs_to :github_repo, GitHubRepo
  end

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, [:title, :body, :github_repo_id])
    |> assoc_constraint(:github_repo)
  end
end