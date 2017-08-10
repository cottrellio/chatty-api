defmodule Chatty.ChannelsTest do
  use Chatty.DataCase

  alias Chatty.Accounts
  alias Chatty.Channels

  describe "channels" do
    alias Chatty.Channels.Channel

    @create_user %{email: "joe@example.com", first_name: "Joe", last_name: "Example", username: "joe.example", password: "abcde12345", password_confirmation: "abcde12345"}
    @valid_attrs %{name: "some name", purpose: "some purpose"}
    @update_attrs %{name: "some updated name", purpose: "some updated purpose"}
    @invalid_attrs %{name: nil, purpose: nil}

    def channel_fixture(attrs \\ %{}) do
      {:ok, user} = Accounts.create_user(@create_user)
      user = %{user | password: nil, password_confirmation: nil}
      {:ok, channel} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Channels.create_channel(user)

      channel
    end

    test "list_channels/0 returns all channels" do
      channel = channel_fixture()
      assert Channels.list_channels() == [channel]
    end

    test "get_channel!/1 returns the channel with given id" do
      channel = channel_fixture()
      assert Channels.get_channel!(channel.id) == channel
    end

    test "create_channel/1 with valid data creates a channel" do
      {:ok, user} = Accounts.create_user(@create_user)
      assert {:ok, %Channel{} = channel} = Channels.create_channel(@valid_attrs, user)
      assert channel.name == "some name"
      assert channel.purpose == "some purpose"
    end

    test "create_channel/1 with invalid data returns error changeset" do
      {:ok, user} = Accounts.create_user(@create_user)
      assert {:error, %Ecto.Changeset{}} = Channels.create_channel(@invalid_attrs, user)
    end

    test "update_channel/2 with valid data updates the channel" do
      channel = channel_fixture()
      assert {:ok, channel} = Channels.update_channel(channel, @update_attrs)
      assert %Channel{} = channel
      assert channel.name == "some updated name"
      assert channel.purpose == "some updated purpose"
    end

    test "update_channel/2 with invalid data returns error changeset" do
      channel = channel_fixture()
      assert {:error, %Ecto.Changeset{}} = Channels.update_channel(channel, @invalid_attrs)
      assert channel == Channels.get_channel!(channel.id)
    end

    test "delete_channel/1 deletes the channel" do
      channel = channel_fixture()
      assert {:ok, %Channel{}} = Channels.delete_channel(channel)
      assert_raise Ecto.NoResultsError, fn -> Channels.get_channel!(channel.id) end
    end

    test "change_channel/1 returns a channel changeset" do
      channel = channel_fixture()
      assert %Ecto.Changeset{} = Channels.change_channel(channel)
    end
  end
end
