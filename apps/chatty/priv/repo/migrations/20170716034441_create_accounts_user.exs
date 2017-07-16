defmodule Chatty.Repo.Migrations.CreateChatty.Accounts.User do
  use Ecto.Migration

  def change do
    create table(:accounts_users) do
      add :email, :string
      add :password_hash, :string
      add :first_name, :string
      add :last_name, :string
      add :username, :string

      timestamps()
    end

    # Add unique email address constraint via DB index.
    create index(:accounts_users, [:email], unique: true)
  end
end
