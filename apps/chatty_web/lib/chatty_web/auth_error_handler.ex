defmodule Chatty.Web.AuthErrorHandler do
  use Chatty.Web, :controller

  def unauthenticated(conn, params) do
    conn
    |> put_status(401)
    |> render(Chatty.ErrorView, "401.json")
  end

  def unauthorized(conn, params) do
    conn
    |> put_status(403)
    |> render(Chatty.ErrorView, "403.json")
  end
end
