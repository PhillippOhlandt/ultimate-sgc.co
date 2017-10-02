defmodule SGC.Auth do
  alias SGC.StargateCommand
  alias SGC.Auth.Login

  def login(params) do
    changeset = Login.changeset(%Login{}, params)

    case changeset.valid? do
      true ->
        do_login(Ecto.Changeset.apply_changes(changeset))
      false ->
        {:error, changeset}
    end
  end

  defp do_login(%Login{username: username, password: password}) do
    case StargateCommand.login(username, password) do
      {:ok, cookies} -> {:ok, cookies}
      {:error, body} -> {:error, body}
    end
  end
end
