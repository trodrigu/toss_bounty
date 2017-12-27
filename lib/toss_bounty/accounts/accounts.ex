defmodule TossBounty.Accounts do
  @moduledoc """
  The Accounts context which includes interactions
  for maintainer users and tossers.
  """

  import Ecto.Query, warn: false
  alias TossBounty.Repo

  alias TossBounty.Accounts.User

  @doc """
  Updates a user.

  ## Examples

  iex> update_user(user, %{field: new_value})
  {:ok, %User{}}

  iex> update_user(user, %{field: bad_value})
  {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end
end
