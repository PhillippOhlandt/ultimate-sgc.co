defmodule SGCWeb.PageController do
  use SGCWeb, :controller

  def index(conn, _params) do
    cookies = create_cookie_list(conn)

    IO.inspect SGC.StargateCommand.user_info(cookies)
    render conn, "index.html"
  end
end
