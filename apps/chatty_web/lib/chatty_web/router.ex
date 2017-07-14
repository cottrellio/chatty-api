defmodule Chatty.Web.Router do
  use Chatty.Web, :router

  pipeline :api do
    plug :accepts, ["json", "json-api"]
  end

  scope "/api", Chatty.Web do
    pipe_through :api
    # Session
    resources "session", SessionController, only: [:index]
  end
end
