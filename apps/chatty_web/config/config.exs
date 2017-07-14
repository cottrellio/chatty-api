# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :chatty_web,
  namespace: Chatty.Web,
  ecto_repos: [Chatty.Repo]

# Configures the endpoint
config :chatty_web, Chatty.Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "hoY3iOcm+lrEbE1r/ChamMyrFFF6nS4A43ro9oSkTnAdrIZOCZ559faTSlzxKmJE",
  render_errors: [view: Chatty.Web.ErrorView, accepts: ~w(json)],
  pubsub: [name: Chatty.Web.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :chatty_web, :generators,
  context_app: :chatty

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
