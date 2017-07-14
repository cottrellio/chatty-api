defmodule Chatty.Web.SessionController do
  use Chatty.Web, :controller

  def index(conn, _params) do
    conn
    |> json(%{status: 200})
  end
end
