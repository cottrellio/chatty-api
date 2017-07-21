defmodule Chatty.Web.SessionController do
  use Chatty.Web, :controller

  import Ecto.Query, only: [where: 3, or_where: 3]
  import Comeonin.Bcrypt
  import Logger

  alias Chatty.Accounts.User
  alias Chatty.Repo

  def create(conn, %{"grant_type" => "password",
    "username" => username,
    "password" => password}) do

    try do
      # Attempt to retrieve exactly one user from the DB, whose email || username
      # matches the one provided with the login request.
      user = User
      |> where([u], u.email == ^username)
      |> or_where([u], u.username == ^username)
      |> Repo.one!
      cond do

        checkpw(password, user.password_hash) ->
          # Successful login.
          Logger.info "User " <> user.username <> " just logged in."
          # Encode a JWT
          { :ok, jwt, _ } = Guardian.encode_and_sign(user, :token)
          conn
          |> json(%{access_token: jwt})

        true ->
          # Unsuccessful login.
          Logger.warn "User " <> user.username <> " just failed to login."
          conn
          |> put_status(401)
          |> render(Chatty.Web.ErrorView, "401.json-api")
      end
    rescue
      e ->
        IO.inspect e
        Logger.error "Unexpected error while attempting to login user #{username}."
        conn
        |> put_status(401)
        |> render(Chatty.Web.ErrorView, "401.json-api")
    end
  end

  def create(conn, %{"grant_type" => _}) do
    ## Handle unknown `grant_type`.
    throw "Unsupported grant_type"
  end
end
