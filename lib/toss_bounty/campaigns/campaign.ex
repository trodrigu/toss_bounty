defmodule TossBounty.Campaigns.Campaign do
  use Ecto.Schema
  import Ecto.Changeset
  alias TossBounty.Campaigns.Campaign
  use Timex.Ecto.Timestamps
  alias TossBounty.Github.GithubRepo
  alias TossBounty.Accounts.User
  alias TossBounty.Incentive.Reward

  schema "campaigns" do
    field(:current_funding, :float)
    field(:funding_goal, :float)
    field(:long_description, :binary)
    belongs_to(:user, User)
    belongs_to(:github_repo, GithubRepo)

    has_many(:rewards, Reward, on_delete: :delete_all)
    timestamps()
  end

  @doc false
  def changeset(%Campaign{} = campaign, attrs) do
    campaign
    |> cast(attrs, [
      :long_description,
      :funding_goal,
      :current_funding,
      :user_id,
      :github_repo_id
    ])
    |> validate_required([
      :long_description,
      :funding_goal,
      :user_id,
      :github_repo_id
    ])
  end
end
