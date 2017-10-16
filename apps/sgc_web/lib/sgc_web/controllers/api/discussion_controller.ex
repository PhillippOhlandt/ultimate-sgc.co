defmodule SGCWeb.Api.DiscussionController do
  use SGCWeb, :controller
  alias SGC.StargateCommand

  def index(conn, params) do
    cookies = create_cookie_list(conn)
    page = Map.get(params, "page", 1)

    with {:ok, data, new_cookies} <- StargateCommand.user_discussions(cookies, page) do
      conn
      |> add_cookies(new_cookies)
      |> render("index.json", data: data)
    end
  end

  def mark_all_read(conn, _) do
    cookies = create_cookie_list(conn)

    with {:ok, new_cookies} <- StargateCommand.mark_all_user_discussions_as_read(cookies) do
      conn
      |> add_cookies(new_cookies)
      |> render("mark_all_read.json")
    end
  end
end
