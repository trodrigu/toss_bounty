defmodule TossBounty.SellableIssues.MockIssuesGrabber do
  @behaviour TossBounty.SellableIssues.Behaviour

  def start_link do
    Agent.start_link(fn -> [] end, name: __MODULE__)
  end

  def filter(_owner, _repo_name, _user) do
    Agent.get(__MODULE__, &(&1))
  end

  def insert_issue(issue) do
    Agent.update(__MODULE__, fn issues -> [issue | issues] end)
  end

  def insert_issues(new_issues) do
    Agent.update(__MODULE__, fn issues -> issues ++ new_issues end)
  end

  def clear do
    Agent.update(__MODULE__, fn _issues -> [] end)
  end
end
