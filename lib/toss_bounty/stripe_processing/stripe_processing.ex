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
  Returns the list of plans.

  ## Examples

  iex> list_plans()
  [%Plan{}, ...]

  """
  def list_plans(%{"subscriber_id" => subscriber_id}) do
    query =
      from(
        p in Plan,
        join: s in assoc(p, :subscriptions),
        join: c in assoc(s, :customer),
        join: t in assoc(c, :token),
        join: u in assoc(t, :user),
        where: u.id == ^subscriber_id
      )

    query
    |> Repo.all()
  end

  def list_plans(%{"campaign_id" => campaign_id}) do
    query =
      from(
        p in Plan,
        join: r in assoc(p, :reward),
        join: c in assoc(r, :campaign),
        where: c.id == ^campaign_id
      )

    query
    |> Repo.all()
  end

  def list_plans do
    Repo.all(Plan)
  end

  @doc """
  Returns the list of subscriptions.

  ## Examples

  iex> list_subscriptions()
  [%Subscription{}, ...]

  """

  def list_subscriptions do
    Repo.all(Subscription)
  end

  def list_subscriptions(%{"user_id" => user_id}) do
    query =
      from(
        s in Subscription,
        join: c in assoc(s, :customer),
        join: t in assoc(c, :token),
        where: t.user_id == ^user_id
      )

    query
    |> Repo.all()
  end

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
  Updates a plan.

  ## Examples

  iex> update_plan(plan, %{field: new_value})
  {:ok, Plan{}}

  iex> update_plan(plan, %{field: bad_value})
  {:error, %Ecto.Changeset{}}

  """
  def update_plan(%Plan{} = plan, attrs) do
    plan
    |> Plan.changeset(attrs)
    |> Repo.update()
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

  @doc """
  Gets a single subscription.

  Raises `Ecto.NoResultsError` if the Subscription does not exist.

  ## Examples

  iex> get_subscription!(123)
  %Subscription{}

  iex> get_subscription!(456)
  ** (Ecto.NoResultsError)

  """
  def get_subscription!(id), do: Repo.get!(Subscription, id)

  @doc """
  Deletes a Subscription.

  ## Examples

  iex> delete_subscription(subcription)
  {:ok, %Subscription{}}

  iex> delete_subscription(subcription)
  {:error, %Ecto.Changeset{}}

  """
  def delete_subscription(%Subscription{} = subcription) do
    Repo.delete(subcription)
  end
end
