defmodule TossBounty.GitHub.SellableRepos.TentacatReposGrabber do
  @behaviour TossBounty.GitHub.SellableRepos.Behaviour

  def list_mine(user) do
    tentacat_client = create_tentacat_client(user)
    repos = Tentacat.Repositories.list_mine(tentacat_client)
  end

  defp create_tentacat_client(user) do
    access_token = user.github_token
    Tentacat.Client.new(%{ access_token: access_token })
  end
end
