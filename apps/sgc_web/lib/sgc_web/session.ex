defmodule SGCWeb.Session do
  @moduledoc """
  Some helpers for session-related things
  """

  def current_user(%{assigns: %{current_user: u}}), do: u
  def current_user(conn) do
    Plug.Conn.get_session(conn, :current_user)
  end

  def logged_in?(conn), do: !!conn.assigns[:current_user]
end
