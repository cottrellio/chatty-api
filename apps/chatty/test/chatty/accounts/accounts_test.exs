defmodule Chatty.AccountsTest do
  use Chatty.DataCase

  alias Chatty.Accounts

  describe "users" do
    alias Chatty.Accounts.User

    @valid_attrs %{email: "joe@example.com", first_name: "Joe", last_name: "Example", username: "joe.example", password: "abcde12345", password_confirmation: "abcde12345"}
    @update_attrs %{email: "joey@example.com", first_name: "Joey", last_name: "Exemplar", username: "joey.exemplar", password: "12345abcde", password_confirmation: "12345abcde"}
    @invalid_attrs %{email: nil, first_name: nil, last_name: nil, password_hash: nil, username: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      # Clear virtual fields from fixture (`password` and `password_confirmation`).
      user = put_in(user.password, nil)
      user = put_in(user.password_confirmation, nil)

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.email == "joe@example.com"
      assert user.first_name == "Joe"
      assert user.last_name == "Example"
      assert user.username == "joe.example"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, user} = Accounts.update_user(user, @update_attrs)
      assert %User{} = user
      assert user.email == "joey@example.com"
      assert user.first_name == "Joey"
      assert user.last_name == "Exemplar"
      assert user.username == "joey.exemplar"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end

    test "mis-matched password_confirmation doesn't work" do
      changeset = User.changeset(%User{}, %{email: "joe@example.com",
        password: "12345abdce",
        password_confirmation: "abcde12345"})
      refute changeset.valid?
    end

    test "missing password_confirmation doesn't work" do
      changeset = User.changeset(%User{}, %{email: "joe@example.com",
        password: "abcde12345"})
      refute changeset.valid?
    end

    test "short password doesn't work" do
      changeset = User.changeset(%User{}, %{email: "joe@example.com",
        password: "abcde",
        password_confirmation: "abcde"})
      refute changeset.valid?
    end
  end
end
