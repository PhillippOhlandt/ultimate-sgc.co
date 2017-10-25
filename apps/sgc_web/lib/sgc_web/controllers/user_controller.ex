defmodule SGCWeb.UserController do
  use SGCWeb, :controller
  alias SGC.StargateCommand

  action_fallback SGCWeb.FallbackController

  def show(conn, %{"id" => id}) do
    cookies = create_cookie_list(conn)

    with {:ok, user, new_cookies} <- StargateCommand.user_info(id, cookies) do
      conn
      |> add_cookies(new_cookies)
      |> render("show.html", user: user)
    end
  end

  def posts(conn, %{"id" => id} = params) do
    cookies = create_cookie_list(conn)
    page = Map.get(params, "page", 1)

    with {:ok, data, new_cookies} <- StargateCommand.user_posts(id, cookies, page) do
      conn
      |> add_cookies(new_cookies)
      |> put_view(SGCWeb.PostView)
      |> render("posts.json", data: data)
    else
      value -> {:json, value}
    end
  end

  def following(conn, %{"id" => id} = params) do
    cookies = create_cookie_list(conn)
    page = Map.get(params, "page", 1)

    with {:ok, data, new_cookies} <- StargateCommand.user_following(id, cookies, page) do
      conn
      |> add_cookies(new_cookies)
      |> render("following.json", data: data)
    else
      value -> {:json, value}
    end
  end

  def followers(conn, %{"id" => id} = params) do
    cookies = create_cookie_list(conn)
    page = Map.get(params, "page", 1)

    with {:ok, data, new_cookies} <- StargateCommand.user_followers(id, cookies, page) do
      conn
      |> add_cookies(new_cookies)
      |> render("followers.json", data: data)
    else
      value -> {:json, value}
    end
  end
end
