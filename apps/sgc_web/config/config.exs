# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :sgc_web,
  namespace: SGCWeb,
  ecto_repos: [SGC.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :sgc_web, SGCWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "10RPPWxpx3NwnEavNuT2VoAIEAbQySTyC4ji77A2VyrYSEqUhP+M+S+hGYGgddog",
  render_errors: [view: SGCWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: SGCWeb.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :sgc_web, :generators,
  context_app: :sgc

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
