defmodule Chatty.Channels.Channel do
  use Ecto.Schema

  import Ecto.Changeset

  alias Chatty.Channels.Channel
  alias Chatty.Accounts.User

  schema "channels_channels" do
    field :name, :string
    field :purpose, :string
    belongs_to :user, User

    timestamps()
  end

  @required_fields ~w(name)a
  @optional_fields ~w(purpose)a
  @all_fields @required_fields ++ @optional_fields

  @doc false
  def changeset(%Channel{} = channel, attrs) do
    channel
    |> cast(attrs, @all_fields)
    |> validate_required(@required_fields)
    |> validate_length(:name, min: 4)
  end
end
