defmodule TossBounty.Github do
  @moduledoc """
  The Github context.
  """

  import Ecto.Query, warn: false
  alias TossBounty.Repo

  alias TossBounty.Github.GithubRepo

  @doc """
  Returns the list of github repos.
  ## Examples

  iex> list_github_repos()
  [%GithubRepo{}, ...]

  """
  def list_github_repos(%{"user_id" => user_id}) do
    GithubRepo
    |> Ecto.Query.where(user_id: ^user_id)
    |> Repo.all()
  end

  def list_github_repos do
    GithubRepo
    |> Repo.all()
  end
end
