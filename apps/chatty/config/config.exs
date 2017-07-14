use Mix.Config

config :chatty, ecto_repos: [Chatty.Repo]

import_config "#{Mix.env}.exs"
