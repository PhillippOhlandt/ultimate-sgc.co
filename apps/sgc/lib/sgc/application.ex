defmodule SGC.Application do
  @moduledoc """
  The SGC Application Service.

  The sgc system business domain lives in this application.

  Exposes API to clients such as the `SGCWeb` application
  for use in channels, controllers, and elsewhere.
  """
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    Supervisor.start_link([
      supervisor(SGC.Repo, []),
    ], strategy: :one_for_one, name: SGC.Supervisor)
  end
end
