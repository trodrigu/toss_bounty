defmodule TossBounty.GitHub.SellableIssues do
  @sellable_issues_impl Application.fetch_env!(:toss_bounty, :issue_grabber)

  defmodule Behaviour do
    @callback filter([owner: String.t, repo_name: String.t, user: TossBounty.Accounts.User.t]) :: :ok
  end

  def call(owner, repo_name, user) do
    @sellable_issues_impl.filter(owner, repo_name, user)
    |> Enum.filter( fn x -> x["reactions"]["total_count"] > 2 end )
    |> Enum.map( fn x -> %{ title: x["title"], body: x["body"], avatar_url: x["user"]["avatar_url"], login: x["user"]["login"] } end)
  end
end
