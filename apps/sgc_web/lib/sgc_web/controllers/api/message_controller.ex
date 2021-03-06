defmodule SGCWeb.Api.MessageController do
  use SGCWeb, :controller
  alias SGC.StargateCommand

  action_fallback SGCWeb.FallbackController

  def index(conn, params) do
    cookies = create_cookie_list(conn)
    page = Map.get(params, "page", 1)

    with {:ok, data, new_cookies} <- StargateCommand.user_messages(cookies, page) do
      conn
      |> add_cookies(new_cookies)
      |> render("index.json", data: data)
    else
      value -> {:json, value}
    end
  end

  def show(conn, %{"id" => id}) do
    cookies = create_cookie_list(conn)

    with {:ok, data, new_cookies} <- StargateCommand.user_message(id, cookies) do
      conn
      |> add_cookies(new_cookies)
      |> render("show.json", data: data)
    else
      value -> {:json, value}
    end
  end

  def store(conn, %{"id" => id} = params) do
    cookies = create_cookie_list(conn)

    with {:ok, message} <- StargateCommand.validate_user_message_input(params),
         {:ok, data, new_cookies} <- StargateCommand.send_user_message(id, message, cookies) do

      conn
      |> add_cookies(new_cookies)
      |> render("store.json", data: data)
    else
      value -> {:json, value}
    end
  end

  def mark_all_read(conn, _) do
    cookies = create_cookie_list(conn)

    with {:ok, new_cookies} <- StargateCommand.mark_all_user_messages_as_read(cookies) do
      conn
      |> add_cookies(new_cookies)
      |> render("mark_all_read.json")
    else
      value -> {:json, value}
    end
  end
end
