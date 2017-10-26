defmodule SGCWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.
  See `Phoenix.Controller.action_fallback/1` for more details.
  """

  use SGCWeb, :controller
  alias SGCWeb.ErrorView

  def call(conn, {:html, {:error, :unauthenticated}}) do
    conn
    |> put_session(:current_user, nil)
    |> assign(:current_user, nil)
    |> put_flash(:info, "Your session expired, please log in again")
    |> redirect(to: session_path(conn, :new))
  end

  def call(conn, {:json, {:error, :unauthenticated}}) do
    conn
    |> put_status(:unauthorized)
    |> put_resp_header("content-type", "application/json")
    |> put_session(:current_user, nil)
    |> assign(:current_user, nil)
    |> put_view(ErrorView)
    |> render("error.json", error: "unauthorized")
  end

  def call(_conn, {:html, value}) do
    value
  end

  def call(_conn, {:json, value}) do
    value
  end

  def call(conn, value) do
    call(conn, {:html, value})
  end
end
