defmodule Chatty.Web.Router do
  use Chatty.Web, :router

  pipeline :api do
    plug :accepts, ["json", "json-api"]
    plug JaSerializer.Deserializer
  end

  # Authenticated requests.
  pipeline :api_auth do
    plug :accepts, ["json", "json-api"]
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource
  end

  scope "/api", Chatty.Web do
    pipe_through :api
    # Registration.
    post "/register", RegistrationController, :create
    # Login.
    post "/token", SessionController, :create, as: :login
  end

  scope "/api", Chatty.Web do
    pipe_through :api_auth
    # Current user.
    get "/users/me", UserController, :current
    # Users
    resources "/users", UserController, only: [:show]
    # Channels.
    resources "/channels", ChannelController, except: [:new, :edit]
  end
end
