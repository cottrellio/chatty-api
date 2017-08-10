defmodule Chatty.Web.RegistrationControllerTest do
  use Chatty.Web.ConnCase

  alias Chatty.Accounts

  @valid_attrs %{email: "joe@example.com", password: "abcde12345", password_confirmation: "abcde12345", username: "joe.example", first_name: "Joe", last_name: "Example"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    conn =
      conn
      |> put_req_header("accept", "application/vnd.api+json")
      |> put_req_header("content-type", "application/vnd.api+json")

    {:ok, conn: conn}
  end

  test "creates user and renders user when data is valid", %{conn: conn} do
    data = %{
      "data": %{
        "type": "user",
        "attributes": @valid_attrs
      }
    }

    resp_data = post(conn, registration_path(conn, :create), data: data)
    |> json_response(201)
    |> Map.get("data")
    assert(resp_data)

    user = Accounts.get_user!(resp_data["id"])
    {:ok, jwt, _} = Guardian.encode_and_sign(user)

    conn =
      conn
      |> put_req_header("authorization", "Bearer #{jwt}")

    resp_data2 = get(conn, user_path(conn, :show, resp_data["id"]))
    |> json_response(200)
    |> Map.get("data")
    assert(resp_data2 == %{
      "id" => resp_data["id"],
      "type" => "user",
      "attributes" => %{
        "email" => "joe@example.com",
        "first-name" => "Joe",
        "last-name" => "Example",
        "username" => "joe.example"}
    })
  end

  test "does not create user and renders errors when data is invalid", %{conn: conn} do
    data = %{
      "data": %{
        "type": "user",
        "attributes": @invalid_attrs
      }
    }

    errors = post(conn, registration_path(conn, :create), data: data)
    |> json_response(422)
    |> Map.get("errors")
    assert(errors != %{})
  end
end
