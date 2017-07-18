defmodule Chatty.Web.RegistrationController do
  use Chatty.Web, :controller

  alias Chatty.Accounts
  alias Chatty.Accounts.User

  def create(conn, %{"data" => data}) do
    attrs = JaSerializer.Params.to_attributes(data)

    case Accounts.create_user attrs do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> render(Chatty.Web.UserView, "show.json-api", data: user)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Chatty.Web.ChangesetView, "error.json-api", data: changeset)
    end
  end
end
