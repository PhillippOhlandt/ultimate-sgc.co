defmodule SGCWeb.Plugs.RequireUser do
  @moduledoc """
  A `Plug` to redirect to the login page if there is no current user
  """

  import Plug.Conn
  import Phoenix.Controller, only: [put_flash: 3, redirect: 2]
  import SGCWeb.Session, only: [logged_in?: 1]

  def init(options), do: options

  def call(conn, _opts) do
    if logged_in?(conn) do
      conn
    else
      conn
      |> put_flash(:error, "You must be logged in to access this page.")
      |> redirect(to: SGCWeb.Router.Helpers.session_path(conn, :new))
      |> halt()
    end
  end
end
