defmodule TossBounty.Github.GithubRepo do
  use Ecto.Schema
  import Ecto.Changeset
  alias TossBounty.Accounts.User
  alias TossBounty.Github.GithubIssue

  schema "github_repos" do
    field(:name, :string)
    field(:owner, :string)
    field(:bountiful_score, :integer)
    field(:image, :string)
    belongs_to(:user, User)
    has_many(:github_issues, GithubIssue)
  end

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, [:name, :owner, :user_id, :bountiful_score, :image])
    |> assoc_constraint(:user)
  end
end
