defmodule SGCWeb.UserController do
  use SGCWeb, :controller
  alias SGC.StargateCommand

  def show(conn, %{"id" => id}) do
    cookies = create_cookie_list(conn)

    with {:ok, user, new_cookies} <- StargateCommand.user_info(id, cookies) do
      conn
      |> add_cookies(new_cookies)
      |> render("show.html", user: user)
    end
  end
end
