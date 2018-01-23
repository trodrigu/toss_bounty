defmodule TossBounty.StripeProcessing do
  @moduledoc """
  Responsible for managing stripe interactions.
  """
  import Ecto.Query, warn: false
  alias TossBounty.Repo
  alias TossBounty.StripeProcessing.Charge

  @doc """
  Creates a charge which stores a one time use token.

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
end
