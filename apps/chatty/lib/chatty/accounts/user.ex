defmodule Chatty.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Chatty.Accounts.User


  schema "accounts_users" do
    field :email, :string
    field :first_name, :string
    field :last_name, :string
    field :password_hash, :string
    field :username, :string

    # Virtual fields for password confirmation.
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true

    timestamps()
  end

  @required_fields ~w(email password password_confirmation username)a
  @optional_fields ~w(first_name last_name)a
  @all_fields @required_fields ++ @optional_fields

  @doc """
  Creates a changeset based on `user` and `attrs`.

  If no attrs are provided, an invalid changeset is returned with no validation
  performed.
  """
  def changeset(%User{} = user, attrs \\ :invalid) do
    user
    |> cast(attrs, @all_fields)
    |> validate_required(@required_fields)
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 8)
    |> validate_confirmation(:password)
    |> hash_password
    |> unique_constraint(:email)
  end

  defp hash_password(%{valid?: false} = changeset), do: changeset
  defp hash_password(%{valid?: true} = changeset) do
    hashedpw = Comeonin.Bcrypt.hashpwsalt(Ecto.Changeset.get_field(changeset, :password))
    Ecto.Changeset.put_change(changeset, :password_hash, hashedpw)
  end
end
