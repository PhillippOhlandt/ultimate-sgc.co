use Mix.Config

# Configure your database
config :sgc, SGC.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "sgc_dev",
  hostname: "localhost",
  pool_size: 10
