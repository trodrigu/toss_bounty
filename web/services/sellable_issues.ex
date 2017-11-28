defmodule TossBounty.SellableIssues do
  @sellable_issues_impl Application.fetch_env!(:toss_bounty, :issue_grabber)

  defmodule Behaviour do
    @callback filter([owner: String.t, repo_name: String.t, user: TossBounty.User.t]) :: :ok
  end

  def call(owner, repo_name, user) do
    @sellable_issues_impl.filter(owner, repo_name, user)
    |> Enum.filter( fn x -> x["reactions"]["total_count"] > 2 end )
    |> Enum.map( fn x -> x["body"] end)
  end
end
