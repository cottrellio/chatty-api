defmodule Chatty.Web.ChannelControllerTest do
  use Chatty.Web.ConnCase

  alias Chatty.Accounts
  alias Chatty.Channels

  @create_user %{email: "joe@example.com", first_name: "Joe", last_name: "Example", username: "joe.example", password: "abcde12345", password_confirmation: "abcde12345"}
  @create_attrs %{name: "some name", purpose: "some purpose"}
  @update_attrs %{name: "some updated name", purpose: "some updated purpose"}
  @invalid_attrs %{name: nil, purpose: nil}

  # defp create_test_channels(user) do
  #   # Create three channels owned by the logged in user
  #   Enum.each ["first channel", "second channel", "third channel"], fn name ->
  #     Channels.create_channel %Channel{user_id: user.id, name: name}
  #   end

    # Create two rooms owned by another user
    # other_user = Repo.insert! %Peepchat.User{}
    # Enum.each ["fourth room", "fifth room"], fn name ->
    #   Repo.insert! %Peepchat.Room{owner_id: other_user.id, name: name}
    # end
  # end

  setup %{conn: conn} do
    {:ok, user} = Accounts.create_user(@create_user)
    {:ok, jwt, _} = Guardian.encode_and_sign(user)

    conn =
      conn
      |> put_req_header("authorization", "Bearer #{jwt}")
      |> put_req_header("accept", "application/vnd.api+json")
      |> put_req_header("content-type", "application/vnd.api+json")

    {:ok, %{conn: conn, user: user}}
  end

  test "lists all entries on index by user id", %{conn: conn, user: user} do
    data = get(conn, channel_path(conn, :index, user_id: user.id))
    |> json_response(200)
    |> Map.get("data")
    assert(data == [])
  end

  test "lists all entries on index", %{conn: conn} do
    data = get(conn, channel_path(conn, :index))
    |> json_response(200)
    |> Map.get("data")
    assert(data == [])
  end

  test "creates channel and renders channel when data is valid", %{conn: conn} do
    data = %{
      "data": %{
        "type": "channel",
        "attributes": @create_attrs
      }
    }

    resp_data = post(conn, channel_path(conn, :create), data: data)
    |> json_response(201)
    |> Map.get("data")
    assert(resp_data)

    resp_data2 = get(conn, channel_path(conn, :show, resp_data["id"]))
    |> json_response(200)
    |> Map.get("data")
    assert(resp_data2 == %{
      "id" => resp_data["id"],
      "type" => "channel",
      "attributes" => %{
        "name" => "some name",
        "purpose" => "some purpose"}
    })
  end

  test "does not create channel and renders errors when data is invalid", %{conn: conn} do
    data = %{
      "data": %{
        "type": "channel",
        "attributes": @invalid_attrs
      }
    }
    errors = post(conn, channel_path(conn, :create), data: data)
    |> json_response(422)
    |> Map.get("errors")
    assert(errors != %{})
  end

  test "updates chosen channel and renders channel when data is valid", %{conn: conn, user: user} do
    {:ok, channel} = Channels.create_channel(%{name: "some name", purpose: "some purpose"}, user)
    id = Integer.to_string(channel.id)
    data = %{
      "data": %{
        "type": "channel",
        "attributes": @update_attrs
      }
    }
    put(conn, channel_path(conn, :update, channel.id), data: data)
    |> json_response(200)
    |> get_in(["data", "id"])
    |> assert(id)

    resp_data = get(conn, channel_path(conn, :show, channel.id))
    |> json_response(200)
    |> Map.get("data")
    assert(resp_data == %{
      "id" => id,
      "type" => "channel",
      "attributes" => %{
        "name" => "some updated name",
        "purpose" => "some updated purpose"}
    })
  end

  test "does not update chosen channel and renders errors when data is invalid", %{conn: conn, user: user} do
    {:ok, channel} = Channels.create_channel(%{name: "some name", purpose: "some purpose"}, user)
    data = %{
      "data": %{
        "type": "channel",
        "attributes": @invalid_attrs
      }
    }
    errors = put(conn, channel_path(conn, :update, channel), data: data)
    |> json_response(422)
    |> Map.get("errors")
    assert(errors != %{})
  end

  test "deletes chosen channel", %{conn: conn, user: user} do
    {:ok, channel} = Channels.create_channel(%{name: "some name", purpose: "some purpose"}, user)
    delete(conn, channel_path(conn, :delete, channel))
    |> response(204)
    |> assert()

    assert_error_sent 404, fn ->
      get(conn, channel_path(conn, :show, channel.id))
    end
  end
end
