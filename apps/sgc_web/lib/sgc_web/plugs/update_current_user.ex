defmodule SGCWeb.Plugs.UpdateCurrentUser do
  @moduledoc """
  A `Plug` to update the current user data
  """

  import Plug.Conn
  import Phoenix.Controller, only: [put_flash: 3, redirect: 2]
  import SGCWeb.Session, only: [current_user: 1]
  import SGCWeb.Controllers.Helpers
  alias SGC.StargateCommand

  def init(options), do: options

  def call(conn, _opts) do
    if user = current_user(conn) do
      conn |> update_user_data(user)
    else
      conn
    end
  end

  def update_user_data(conn, %{user_id: id, updated_at: updated}) do
    diff = DateTime.diff(DateTime.utc_now(), updated)
    cond do
      diff > 600 -> conn |> fetch_data_and_assign(id)
      true -> conn
    end
  end
  def update_user_data(conn, %{user_id: id}) do
    conn |> fetch_data_and_assign(id)
  end
  def update_user_data(conn, _user), do: conn

  def fetch_data_and_assign(conn, id) do
    cookies = create_cookie_list(conn)

    case StargateCommand.user_info(id, cookies) do
      {:ok, user_data, _} ->
        user_data = Map.put(user_data, :updated_at, DateTime.utc_now())

        conn
        |> put_session(:current_user, user_data)
        |> assign(:current_user, user_data)
      {:error, :unauthenticated} ->
        conn
        |> put_session(:current_user, nil)
        |> assign(:current_user, nil)
        |> put_flash(:info, "Your session expired, please log in again")
        |> redirect(to: SGCWeb.Router.Helpers.session_path(conn, :new))
        |> halt()
    end
  end
end
