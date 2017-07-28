defmodule Chatty.Web.RegistrationController do
  use Chatty.Web, :controller

  import Logger

  alias Chatty.Accounts

  def create(conn, %{"data" => data}) do
    attrs = JaSerializer.Params.to_attributes(data)

    case Accounts.create_user attrs do
      {:ok, user} ->
        Logger.info("Account was successfully created for " <> user.email <> ".")

        conn
        |> put_status(:created)
        |> render(Chatty.Web.UserView, "show.json-api", data: user)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Chatty.Web.ChangesetView, "error.json", data: changeset)
    end
  end
end
