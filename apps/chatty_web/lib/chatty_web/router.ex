defmodule Chatty.Web.Router do
  use Chatty.Web, :router

  pipeline :api do
    plug :accepts, ["json", "json-api"]
  end

  scope "/api", Chatty.Web do
    pipe_through :api
    # Register
    post "/register", RegistrationController, :create
    # Session
    resources "/session", SessionController, only: [:index]
    # Accounts_User
    resources "/users", UserController, except: [:new, :edit]
  end
end
