defmodule SGCWeb.Plugs.RequireGuest do
  @moduledoc """
  A `Plug` to redirect to the home page if the user is already logged in
  """

  import Plug.Conn
  import Phoenix.Controller, only: [put_flash: 3, redirect: 2]
  import SGCWeb.Session, only: [logged_in?: 1]

  def init(options), do: options

  def call(conn, _opts) do
    if logged_in?(conn) do
      conn
      |> put_flash(:info, "You are already logged in.")
      |> redirect(to: SGCWeb.Router.Helpers.page_path(conn, :index))
      |> halt()
    else
      conn
    end
  end
end
