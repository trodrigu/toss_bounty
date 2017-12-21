defmodule TossBountyWeb.AuthController do
  use TossBountyWeb.Web, :controller
  alias TossBounty.User
  alias TossBountyWeb.SellableRepos
  alias TossBountyWeb.SellableIssues
  alias TossBounty.GitHubRepo
  alias TossBountyWeb.GitHubIssue

  @doc """
  This action is reached via `/auth/:provider/callback` is the callback URL that
  the OAuth2 provider will redirect the user back to with a `code` that will
  be used to request an access token. The access token will then be used to
  access protected resources on behalf of the user.
  """
  def callback(conn, %{"provider" => provider, "code" => code}) do
    # Exchange an auth code for an access token
    client = get_token!(provider, code)

    user_data_from_response = get_user!(provider, client)

    email = user_data_from_response[:email]
    github_token = client.token.access_token

    user_from_db = Repo.get_by(User, email: email)
    user = sign_up_or_return_user(user_from_db, email)

    user_with_updated_github_token = update_user_with_github_token(user, github_token)

    sellable_repos = SellableRepos.call(user)
    save_new_repos(sellable_repos, user)

    repos_and_sellable_issues = find_sellable_issues(sellable_repos, user)
    save_new_issues(repos_and_sellable_issues)


    {:ok, token, _claims} =
      user_with_updated_github_token
      |> Guardian.encode_and_sign(:token)

    user_id = user_with_updated_github_token.id
    front_end_url = Application.fetch_env!(:toss_bounty, :front_end_url)
    total_redirect_url = front_end_url <> "/#/save-session/?token=#{token}&email=#{email}&user_id=#{user_id}"

    conn
    |> Plug.Conn.assign(:current_user, user_with_updated_github_token)
    |> redirect(external: total_redirect_url)
  end

  defp update_user_with_github_token(user, github_token) do
    user = Ecto.Changeset.change user, github_token: github_token
    with {:ok, user} <- Repo.update(user), do: user
  end

  defp sign_up_or_return_user(user, email) when is_nil(user) do
    with {:ok, user} <- Repo.insert!(%User{email: email}), do: user
  end
  defp sign_up_or_return_user(user, _email), do: user

  defp authorize_url!("github"), do: GitHub.authorize_url!

  defp get_token!("github", code), do: GitHub.get_token!(code: code)

  defp get_user!("github", client), do: GitHub.get_user!(client)

  defp save_new_repos(repos, user) do
    repos
    |> Enum.each(fn repo -> save_repo_if_new(repo, user) end)
  end

  defp save_repo_if_new(repo, user) do
    repo_from_db = Repo.get_by(GitHubRepo, name: repo[:name], owner: repo[:owner], user_id: user.id)
    save_or_return_github_repo(repo_from_db, repo, user)
  end

  defp save_or_return_github_repo(repo_from_db, repo_from_service, user) when is_nil(repo_from_db) do
    changeset = GitHubRepo.changeset(%GitHubRepo{}, %{name: repo_from_service[:name], owner: repo_from_service[:owner], user_id: user.id, bountiful_score: repo_from_service[:bountiful_score], image: repo_from_service[:image]})
    Repo.insert!(changeset)
  end
  defp save_or_return_github_repo(repo_from_db, _repo_from_service, _user), do: repo_from_db

  defp find_sellable_issues(sellable_repos, user) do
    Enum.map(sellable_repos, fn repo -> %{ name: repo[:name], issues: SellableIssues.call(repo[:name], repo[:owner], user) } end)
  end

  defp save_new_issues(repos_and_sellable_issues) do
    Enum.each(repos_and_sellable_issues, fn repo_and_sellable_issues -> save_or_return_issues(repo_and_sellable_issues) end)
  end

  defp save_or_return_issues(repo_and_sellable_issues) do
    name = repo_and_sellable_issues[:name]
    repo = Repo.get_by(GitHubRepo, name: name)
    issues = repo_and_sellable_issues[:issues]
    |> Enum.each(fn issue -> run_through_issues(issue, repo) end)
  end

  defp run_through_issues(issue, repo_from_db) do
    issue_from_db = Repo.get_by(GitHubIssue, title: issue[:title], body: issue[:body], github_repo_id: repo_from_db.id)
    save_or_return_issue(issue_from_db, issue, repo_from_db)
  end

  defp save_or_return_issue(issue_from_db, issue, repo_from_db) when is_nil(issue_from_db) do
    changeset = GitHubIssue.changeset(%GitHubIssue{}, %{title: issue[:title], body: issue[:body], github_repo_id: repo_from_db.id})
    Repo.insert!(changeset)
  end
  defp save_or_return_issue(issue_from_db, _issue, _repo_from_db), do: issue_from_db
end
