defmodule TossBounty.StripeProcessing do
  @moduledoc """
  Responsible for managing stripe interactions.
  """
  import Ecto.Query, warn: false
  alias TossBounty.Repo
  alias TossBounty.StripeProcessing.Charge
  alias TossBounty.StripeProcessing.Token

  @doc """
  Creates a charge which records the results of charging against
  a one time token.

  ## Examples

  iex> create_charge(%{field: value})
  {:ok, %Campaign{}}

  iex> create_charge(%{field: bad_value})
  {:error, %Ecto.Changeset{}}

  """
  def create_charge(attrs \\ %{}) do
    %Charge{}
    |> Charge.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Creates a token record which stores a one time use stripe credit
  card token as the uuid.

  ## Examples

  iex> create_token(%{field: value})
  {:ok, %Campaign{}}

  iex> create_token(%{field: bad_value})
  {:error, %Ecto.Changeset{}}

  """
  def create_token(attrs \\ %{}) do
    %Token{}
    |> Token.changeset(attrs)
    |> Repo.insert()
  end
end
