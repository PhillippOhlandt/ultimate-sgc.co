defmodule SGCWeb.SessionController do
  use SGCWeb, :controller
  alias SGC.Auth
  alias SGC.Auth.Login
  alias SGC.StargateCommand

  plug :scrub_params, "session" when action in [:create]

  def new(conn, _params) do
    changeset = Login.changeset(%Login{}, %{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"session" => session_params}) do
    case Auth.login(session_params) do
      {:ok, cookies} ->
        {:ok, user_data, cookies} = StargateCommand.user_info(cookies)

        conn
        |> add_cookies(cookies)
        |> put_session(:current_user, user_data)
        |> put_flash(:info, "Successfully logged in.")
        |> redirect(to: page_path(conn, :index))
      {:error, %Ecto.Changeset{} = changeset} ->
        changeset = %{changeset | action: :create}
        render(conn, "new.html", changeset: changeset)
      {:error, reason} ->
        conn
        |> put_flash(:error, reason)
        |> redirect(to: session_path(conn, :new))
    end
  end

  def delete(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> put_flash(:info, "See you later!")
    |> redirect(to: page_path(conn, :index))
  end
end
