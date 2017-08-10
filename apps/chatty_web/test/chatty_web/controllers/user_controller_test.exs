defmodule Chatty.Web.UserControllerTest do
  use Chatty.Web.ConnCase

  alias Chatty.Accounts
  # alias Chatty.Accounts.User

  @create_attrs %{email: "joe@example.com", first_name: "Joe", last_name: "Example", username: "joe.example", password: "abcde12345", password_confirmation: "abcde12345"}
  # @update_attrs %{email: "joey@example.com", first_name: "Joey", last_name: "Exemplar", username: "joey.exemplar", password: "12345abcde", password_confirmation: "12345abcde"}
  # @invalid_attrs %{email: nil, first_name: nil, last_name: nil, password: nil, password_confirmation: nil, username: nil}

  def fixture(:user) do
    {:ok, user} = Accounts.create_user(@create_attrs)
    user
  end

  setup %{conn: conn} do
    user = fixture(:user)
    {:ok, jwt, _} = Guardian.encode_and_sign(user)

    conn =
      conn
      |> put_req_header("authorization", "Bearer #{jwt}")
      |> put_req_header("accept", "application/vnd.api+json")
      |> put_req_header("content-type", "application/vnd.api+json")

    {:ok, %{conn: conn, user: user}}
  end

  # test "lists all entries on index", %{conn: conn} do
  #   conn = get conn, user_path(conn, :index)
  #   assert json_response(conn, 200)["data"] == []
  # end

  # test "creates user and renders user when data is valid", %{conn: conn} do
  #   conn = post conn, user_path(conn, :create), user: @create_attrs
  #   assert %{"id" => id} = json_response(conn, 201)["data"]

  #   conn = get conn, user_path(conn, :show, id)
  #   assert json_response(conn, 200)["data"] == %{
  #     "id" => id,
  #     "type" => "user",
  #     "attributes" => %{
  #       "email" => "joe@example.com",
  #       "first-name" => "Joe",
  #       "last-name" => "Example",
  #       "username" => "joe.example"}
  #     }
  # end

  # test "does not create user and renders errors when data is invalid", %{conn: conn} do
  #   conn = post conn, user_path(conn, :create), user: @invalid_attrs
  #   assert json_response(conn, 422)["errors"] != %{}
  # end

  # test "updates chosen user and renders user when data is valid", %{conn: conn} do
  #   %User{} = user = fixture(:user)
  #   conn = put conn, user_path(conn, :update, user), user: @update_attrs
  #   assert %{"id" => id} = json_response(conn, 200)["data"]

  #   conn = get conn, user_path(conn, :show, id)
  #   assert json_response(conn, 200)["data"] == %{
  #     "id" => id,
  #     "type" => "user",
  #     "attributes" => %{
  #       "email" => "joey@example.com",
  #       "first-name" => "Joey",
  #       "last-name" => "Exemplar",
  #       "username" => "joey.exemplar"}
  #     }
  # end

  # test "does not update chosen user and renders errors when data is invalid", %{conn: conn} do
  #   user = fixture(:user)
  #   conn = put conn, user_path(conn, :update, user), user: @invalid_attrs
  #   assert json_response(conn, 422)["errors"] != %{}
  # end

  # test "deletes chosen user", %{conn: conn} do
  #   user = fixture(:user)
  #   conn = delete conn, user_path(conn, :delete, user)
  #   assert response(conn, 204)
  #   assert_error_sent 404, fn ->
  #     get conn, user_path(conn, :show, user)
  #   end
  # end

  test "shows current user", %{conn: conn, user: user} do
    data = get(conn, user_path(conn, :current))
    |> json_response(200)
    |> Map.get("data")
    assert(data == %{
      "id" => Integer.to_string(user.id),
      "type" => "user",
      "attributes" => %{
        "email" => "joe@example.com",
        "first-name" => "Joe",
        "last-name" => "Example",
        "username" => "joe.example"}
    })
  end
end
