defmodule TossBounty.GitHub.SellableIssues.TentacatIssuesGrabber do
  @behaviour TossBounty.GitHub.SellableIssues.Behaviour

  alias Tentacat.Issues

  def filter(owner, repo_name, user) do
    tentacat_client = create_tentacat_client(user)
    filtered_issues_from_response = Issues.filter(owner, repo_name, %{state: "open"}, tentacat_client)
    case filtered_issues_from_response do
      {404, _} -> []

      _ -> filtered_issues_from_response
    end
  end

  defp create_tentacat_client(user) do
    access_token = user.github_token
    Tentacat.Client.new(%{ access_token: access_token })
  end
end
