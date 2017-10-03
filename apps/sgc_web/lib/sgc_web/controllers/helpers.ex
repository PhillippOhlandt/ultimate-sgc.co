defmodule SGCWeb.Controllers.Helpers do
  import Plug.Conn
  alias SGC.Cookie

  def add_cookies(conn, cookies) do
    conn = cookies
    |> Enum.reduce(conn, fn (%Cookie{name: name, value: value}, accum) ->
       put_resp_cookie(accum, name, value, http_only: true)
     end)
  end
end
