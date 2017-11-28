defmodule TossBounty.SellableRepos do
  @sellable_repo_impl Application.fetch_env!(:toss_bounty, :repo_grabber)

  defmodule Behaviour do
    @callback list_mine([user: TossBounty.User.t]) :: :ok
  end

  def call(user) do
    @sellable_repo_impl.list_mine(user)
    |> Enum.filter(fn(x) -> x[:open_issues_count] > 0 end)
    |> Enum.map(fn(x) -> x[:name] end)
  end
end
