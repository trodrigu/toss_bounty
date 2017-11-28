defmodule TossBounty.SellableIssues.TentacatIssuesGrabber do
  @behaviour TossBounty.SellableIssues.Behaviour

  alias Tentacat.Issues

  def filter(owner, repo_name, user) do
    tentacat_client = create_tentacat_client(user)
    Issues.filter(owner, repo_name, %{state: "open"}, tentacat_client)
  end

  defp create_tentacat_client(user) do
    access_token = user.github_token
    Tentacat.Client.new(%{ access_token: access_token })
  end
end
