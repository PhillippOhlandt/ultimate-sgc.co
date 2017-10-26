defmodule SGCWeb.Plugs.RequireUser do
  @moduledoc """
  A `Plug` to redirect to the login page if there is no current user
  """

  import Plug.Conn
  import Phoenix.Controller
  import SGCWeb.Session, only: [logged_in?: 1]
  alias SGCWeb.ErrorView

  def init(options), do: options

  def call(conn, opts) do
    format = Keyword.get(opts, :format, :html)
    do_call(conn, format)
  end

  defp do_call(conn, :html) do
    if logged_in?(conn) do
      conn
    else
      conn
      |> put_flash(:error, "You must be logged in to access this page.")
      |> redirect(to: SGCWeb.Router.Helpers.session_path(conn, :new))
      |> halt()
    end
  end

  defp do_call(conn, :json) do
    if logged_in?(conn) do
      conn
    else
      conn
      |> put_status(:unauthorized)
      |> put_resp_header("content-type", "application/json")
      |> put_view(ErrorView)
      |> render("error.json", error: "unauthorized")
      |> halt()
    end
  end
end
