defmodule Chatty.Web.ChannelController do
  use Chatty.Web, :controller

  import Ecto.Query, only: [where: 3, from: 2]

  alias Account.User
  alias Chatty.Channels
  alias Chatty.Channels.Channel
  alias Chatty.Repo

  plug Guardian.Plug.EnsureAuthenticated, handler: Chatty.Web.AuthErrorHandler

  action_fallback Chatty.Web.FallbackController

  # List of channels by user.
  def index(conn, %{"user_id" => user_id}) do
    current_user = Guardian.Plug.current_resource(conn)
    channels = Channels.list_channels(current_user)

    render(conn, "index.json-api", data: channels)
  end

  # List of channels.
  def index(conn, _params) do
    channels = Channels.list_channels()
    render(conn, "index.json-api", data: channels)
  end

  def create(conn, %{"data" => data}) do
    # Get the current user
    current_user = Guardian.Plug.current_resource(conn)

    # Deserialize attrs, add current user_id.
    attrs = JaSerializer.Params.to_attributes(data)

    case Channels.create_channel(attrs, current_user) do
      {:ok, channel} ->
        conn
        |> put_status(:created)
        |> render(Chatty.Web.ChannelView, "show.json-api", data: channel)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Chatty.Web.ChangesetView, "error.json-api", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    channel = Channels.get_channel!(id)
    render(conn, "show.json-api", data: channel)
  end

  def update(conn, %{"data" => data, "id" => id}) do
    # Get the current user
    current_user = Guardian.Plug.current_resource(conn)

    # Deserialize attrs
    attrs = JaSerializer.Params.to_attributes(data)

    # Get channel by id (only if current_user is the channel creator).
    query =
      from c in Channel,
        where: c.id == ^id and c.user_id == ^current_user.id,
        preload: :user
    channel = Repo.one(query)

    case Channels.update_channel(channel, attrs) do
      {:ok, channel} ->
        render(conn, Chatty.Web.ChannelView, "show.json-api", data: channel)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Chatty.Web.ChangesetView, "error.json-api", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    # Get the current user
    current_user = Guardian.Plug.current_resource(conn)

    query =
      from c in Channel,
        where: c.id == ^id and c.user_id == ^current_user.id,
        preload: :user

    case Repo.one(query) do
      channel ->
        with {:ok, %Channel{}} <- Channels.delete_channel(channel) do
          send_resp(conn, :no_content, "")
        end
      nil ->
        conn
        |> put_status(:not_found)
        |> render(Chatty.Web.ErrorView, "404.json-api", data: %{ detail: "Channel with id `" <> id <> "` does not exist." })
    end
  end
end
