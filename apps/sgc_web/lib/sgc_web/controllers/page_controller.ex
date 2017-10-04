defmodule SGCWeb.PageController do
  use SGCWeb, :controller

  def index(conn, _params) do
    #cookies = create_cookie_list(conn)

    #IO.inspect SGC.StargateCommand.user_info(cookies)
    #IO.inspect conn.assigns.current_user
    render conn, "index.html"
  end
end
