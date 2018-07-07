defmodule TossBounty.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias TossBounty.Accounts.User
  alias TossBounty.Campaigns.Campaign

  @doc """
  Schema for users which includes a role reflecting the following.

  ## Examples

      iex> user.role
      0 # :none

      iex> user.role
      1 # :contributor

      iex> user.role
      2 # :maintainer

      iex> user.role
      3 # :both

  """
  schema "users" do
    field(:name, :string)
    field(:email, :string)
    field(:password, :string, virtual: true)
    field(:password_hash, :string)
    field(:github_token, :string)
    field(:stripe_access_token, :string)
    field(:stripe_external_id, :string)
    field(:role, :integer)
    timestamps
    has_many(:campaigns, Campaign)
  end

  def github_registration_changeset(%User{} = user, params \\ %{}) do
    user
    |> cast(params, [:email, :github_token])
    |> validate_required([:email])
    |> unique_constraint(:email)
  end

  def changeset(%User{} = user, params \\ %{}) do
    user
    |> cast(params, [:email, :stripe_external_id, :stripe_access_token, :role])
  end

  def registration_changeset(%User{} = user, params) do
    user
    |> changeset(params)
    |> cast(params, [:password, :email, :name])
    |> validate_required(:password)
    |> validate_length(:password, min: 6, max: 100)
    |> validate_confirmation(:password, message: "does not match password!")
    |> unique_constraint(:email)
    |> put_pass_hash()
  end

  def put_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(pass))

      _ ->
        changeset
    end
  end
end
