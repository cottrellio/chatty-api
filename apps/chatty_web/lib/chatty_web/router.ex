defmodule Chatty.Web.Router do
  use Chatty.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", Chatty.Web do
    pipe_through :api
  end
end
