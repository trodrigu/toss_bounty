defmodule TossBounty.User do
  use TossBounty.Web, :model

  schema "users" do
    field :name, :string
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    timestamps()
  end

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, [:name, :email])
    |> validate_required([:name, :email])
  end

  def registration_changeset(model, params) do
    model
    |> changeset(params)
    |> cast(params, [:password])
    |> validate_required(:password)
    |> validate_length(:password, min: 6, max: 100)
    |> validate_confirmation(:password, message: "does not match password!")
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
