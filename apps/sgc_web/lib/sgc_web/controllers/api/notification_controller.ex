defmodule SGCWeb.Api.NotificationController do
  use SGCWeb, :controller
  alias SGC.StargateCommand

  def index(conn, params) do
    cookies = create_cookie_list(conn)
    page = Map.get(params, "page", 1)

    with {:ok, data, new_cookies} <- StargateCommand.user_notifications(cookies, page) do
      conn
      |> add_cookies(new_cookies)
      |> render("index.json", data: data)
    end
  end
end
