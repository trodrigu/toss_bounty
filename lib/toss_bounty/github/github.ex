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

  @doc """
  Gets a single github_repo.

  Raises `Ecto.NoResultsError` if the GithubRepo does not exist.

  ## Examples

  iex> get_github_repo!(123)
  %GithubRepo{}

  iex> get_github_repo!(456)
  ** (Ecto.NoResultsError)

  """
  def get_github_repo!(id), do: Repo.get!(GithubRepo, id)
end
