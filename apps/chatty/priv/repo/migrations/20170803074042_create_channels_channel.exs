defmodule Chatty.Repo.Migrations.CreateChatty.Channels.Channel do
  use Ecto.Migration

  def change do
    create table(:channels_channels) do
      add :name, :string
      add :purpose, :string
      add :user_id, references(:accounts_users, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:channels_channels, [:user_id])
  end
end
