defmodule Chatty.Web.RegistrationControllerTest do
  use Chatty.Web.ConnCase

  @valid_attrs %{
    email: "joe@example.com",
    password: "abcde12345",
    password_confirmation: "abcde12345",
    username: "joe.example",
    first_name: "Joe",
    last_name: "Example"
  }
  @invalid_attrs %{}

  setup %{conn: conn} do
    conn =
      conn
      |> put_req_header("accept", "application/vnd.api+json")
      |> put_req_header("content-type", "application/vnd.api+json")

    {:ok, conn: conn}
  end

  test "creates user and renders user when data is valid", %{conn: conn} do
    conn = post conn, user_path(conn, :create), user: @valid_attrs
    assert %{"id" => id} = json_response(conn, 201)["data"]

    conn = get conn, user_path(conn, :show, id)
    assert json_response(conn, 200)["data"] == %{
      "id" => id,
      "type" => "user",
      "attributes" => %{
        "email" => "joe@example.com",
        "first-name" => "Joe",
        "last-name" => "Example",
        "username" => "joe.example"}
      }
  end

  test "does not create user and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, user_path(conn, :create), user: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end
end
