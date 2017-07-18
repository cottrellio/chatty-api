defmodule Chatty.Web.UserView do
  use Chatty.Web, :view
  use JaSerializer.PhoenixView

  attributes [:email, :first_name, :last_name, :username]
  # def render("index.json", %{users: users}) do
  #   %{data: render_many(users, UserView, "user.json")}
  # end

  # def render("show.json", %{user: user}) do
  #   %{data: render_one(user, UserView, "user.json")}
  # end

  # def render("user.json", %{user: user}) do
  #   %{id: user.id,
  #     email: user.email,
  #     password_hash: user.password_hash,
  #     first_name: user.first_name,
  #     last_name: user.last_name,
  #     username: user.username}
  # end
end
