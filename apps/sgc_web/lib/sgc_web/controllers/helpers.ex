defmodule SGCWeb.Controllers.Helpers do
  import Plug.Conn
  alias SGC.Cookie

  def add_cookies(conn, cookies) do
    cookies
    |> Enum.reduce(conn, fn (%Cookie{name: name, value: value}, accum) ->
       put_resp_cookie(accum, name, value, http_only: true)
     end)
  end

  def create_cookie_list(conn) do
    conn.req_cookies
    |> Enum.map(fn({name, value})->
      %SGC.Cookie{name: name, value: value}
    end)
  end
end
