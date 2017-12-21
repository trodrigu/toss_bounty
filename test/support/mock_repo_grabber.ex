defmodule TossBounty.GitHub.SellableRepos.MockReposGrabber do
  @behaviour TossBounty.GitHub.SellableRepos.Behaviour

  def start_link do
    Agent.start_link(fn -> [] end, name: __MODULE__)
  end

  def list_mine(_user) do
    Agent.get(__MODULE__, &(&1))
  end

  def insert_repo(repo) do
    Agent.update(__MODULE__, fn repos -> [repo | repos] end)
  end

  def insert_repos(new_repos) do
    Agent.update(__MODULE__, fn repos -> repos ++ new_repos end)
  end

  def clear do
    Agent.update(__MODULE__, fn _repos -> [] end)
  end
end
