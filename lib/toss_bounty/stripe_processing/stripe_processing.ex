defmodule TossBounty.StripeProcessing do
  @moduledoc """
  Responsible for managing stripe interactions.
  """
  import Ecto.Query, warn: false
  alias TossBounty.Repo
  alias TossBounty.StripeProcessing.Subscription
  alias TossBounty.StripeProcessing.Plan
  alias TossBounty.StripeProcessing.Customer
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

  @doc """
  Creates a customer record which stores a customer uuid
  used to associate subscriptions to.

  ## Examples

  iex> create_customer(%{field: value})
  {:ok, %Campaign{}}

  iex> create_customer(%{field: bad_value})
  {:error, %Ecto.Changeset{}}

  """
  def create_customer(attrs \\ %{}) do
    %Customer{}
    |> Customer.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Creates a plan record which stores a plan uuid
  used to create a subscription for a customer.

  ## Examples

  iex> create_plan(%{field: value})
  {:ok, %Plan{}}

  iex> create_plan(%{field: bad_value})
  {:error, %Ecto.Changeset{}}

  """
  def create_plan(attrs \\ %{}) do
    %Plan{}
    |> Plan.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Gets a single plan.

  Raises `Ecto.NoResultsError` if the Plan does not exist.

  ## Examples

  iex> get_plan!(123)
  %Campaign{}

  iex> get_plan!(456)
  ** (Ecto.NoResultsError)

  """
  def get_plan!(id), do: Repo.get!(Plan, id)

  @doc """
  Deletes a Plan.

  ## Examples

  iex> delete_plan(plan)
  {:ok, %Plan{}}

  iex> delete_plan(plan)
  {:error, %Ecto.Changeset{}}

  """
  def delete_plan(%Plan{} = plan) do
    Repo.delete(plan)
  end

  @doc """
  Creates a subscription record which stores a subscription uuid
  resulting from associating a customer with a plan.

  ## Examples

  iex> create_subscription(%{field: value})
  {:ok, %Subscription{}}

  iex> create_subscription(%{field: bad_value})
  {:error, %Ecto.Changeset{}}

  """
  def create_subscription(attrs \\ %{}) do
    %Subscription{}
    |> Subscription.changeset(attrs)
    |> Repo.insert()
  end
end
