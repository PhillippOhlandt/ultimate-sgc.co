use Mix.Config

config :sgc, ecto_repos: [SGC.Repo]

import_config "#{Mix.env}.exs"
