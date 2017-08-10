defmodule Chatty.Web.UserController do
  use Chatty.Web, :controller

  alias Chatty.Accounts
  alias Chatty.Accounts.User

  plug Guardian.Plug.EnsureAuthenticated, handler: Chatty.Web.AuthErrorHandler

  action_fallback Chatty.Web.FallbackController

  # def index(conn, _params) do
  #   users = Accounts.list_users()
  #   render(conn, "index.json-api", data: users)
  # end

  # def create(conn, %{"user" => user_params}) do
  #   with {:ok, %User{} = user} <- Accounts.create_user(user_params) do
  #     conn
  #     |> put_status(:created)
  #     # |> put_resp_header("location", user_path(conn, :show, user))
  #     |> render("show.json-api", data: user)
  #   end
  # end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, "show.json-api", data: user)
  end

  # def update(conn, %{"id" => id, "user" => user_params}) do
  #   user = Accounts.get_user!(id)

  #   with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
  #     render(conn, "show.json-api", data: user)
  #   end
  # end

  # def delete(conn, %{"id" => id}) do
  #   user = Accounts.get_user!(id)
  #   with {:ok, %User{}} <- Accounts.delete_user(user) do
  #     send_resp(conn, :no_content, "")
  #   end
  # end

  def current(conn, _) do
    user = Guardian.Plug.current_resource(conn)
    render(conn, Chatty.Web.UserView, "show.json-api", data: user)
  end
end
