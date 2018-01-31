defmodule TossBounty.Campaigns.Campaign do
  use Ecto.Schema
  import Ecto.Changeset
  alias TossBounty.Campaigns.Campaign
  use Timex.Ecto.Timestamps
  alias TossBounty.Github.GithubRepo
  alias TossBounty.Accounts.User

  schema "campaigns" do
    field(:current_funding, :float)
    field(:funding_end_date, Timex.Ecto.DateTimeWithTimezone)
    field(:funding_goal, :float)
    field(:long_description, :binary)
    field(:short_description, :string)
    belongs_to(:user, User)
    belongs_to(:github_repo, GithubRepo)

    timestamps()
  end

  @doc false
  def changeset(%Campaign{} = campaign, attrs) do
    campaign
    |> cast(attrs, [
      :short_description,
      :long_description,
      :funding_goal,
      :current_funding,
      :funding_end_date,
      :user_id,
      :github_repo_id
    ])
    |> validate_required([
      :short_description,
      :long_description,
      :funding_goal,
      :funding_end_date,
      :user_id,
      :github_repo_id
    ])
  end
end
