defmodule Chatty.Web.UserView do
  use Chatty.Web, :view
  use JaSerializer.PhoenixView

  attributes [:email, :first_name, :last_name, :username]
end
