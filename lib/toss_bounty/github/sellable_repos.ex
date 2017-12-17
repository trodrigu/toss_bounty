defmodule TossBountyWeb.SellableRepos do
  @sellable_repo_impl Application.fetch_env!(:toss_bounty, :repo_grabber)

  defmodule Behaviour do
    @callback list_mine([user: TossBountyWeb.User.t]) :: :ok
  end

  def call(user) do
    sellable_repos =
      @sellable_repo_impl.list_mine(user)
      |> Enum.filter(fn(x) -> x["stargazers_count"] > 0 end)
      |> Enum.map(fn(repo) -> %{ name: repo["name"], owner: repo["owner"]["login"], bountiful_score: calculate_bountiful_score(repo), image: repo["owner"]["avatar"] } end)
  end

  defp calculate_bountiful_score(repo) do
    stargazers_count = repo["stargazers_count"]
    look_up_tier(stargazers_count)
  end

  defp look_up_tier(stargazers_count) do
    index =
      tiers
      |> Enum.find_index(fn (tier) -> check_tier(tier, stargazers_count) end)
    return_index(index)
  end

  defp check_tier(tier, stargazers_count) do
    Enum.member?( tier, stargazers_count )
  end

  defp return_index(nil), do: 5
  defp return_index(index), do: index

  defp tiers do
    [
      1..20,
      20..40,
      40..60,
      60..80,
      80..100,
    ]
  end
end
