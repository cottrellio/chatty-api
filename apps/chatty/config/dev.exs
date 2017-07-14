use Mix.Config

# Configure your database
config :chatty, Chatty.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "chatty_dev",
  hostname: "localhost",
  pool_size: 10
