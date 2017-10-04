defmodule SGCWeb.PageControllerTest do
  use SGCWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Welcome to SGC!"
  end
end
