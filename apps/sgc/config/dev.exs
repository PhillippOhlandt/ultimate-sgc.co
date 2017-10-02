use Mix.Config

# Configure your database
config :sgc, SGC.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: System.get_env("POSTGRES_USER") || "postgres",
  password: System.get_env("POSTGRES_PASSWORD") || "postgres",
  database: "sgc_dev",
  hostname: System.get_env("POSTGRES_HOSTNAME") || "localhost",
  port: System.get_env("POSTGRES_PORT") || 5432,
  pool_size: 10
