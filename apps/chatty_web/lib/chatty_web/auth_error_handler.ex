defmodule Chatty.Web.AuthErrorHandler do
  use Chatty.Web, :controller

  def unauthenticated(conn, params) do
    conn
    |> put_status(401)
    |> render(Chatty.Web.ErrorView, "401.json-api")
  end

  def unauthorized(conn, params) do
    conn
    |> put_status(403)
    |> render(Chatty.Web.ErrorView, "403.json-api")
  end
end
