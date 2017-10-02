defmodule SGC.CookieTest do

  use ExUnit.Case, async: true
  alias SGC.Cookie

  test "parse_from_header/1 parses Set-Cookie headers into a cookie struct" do
    assert %Cookie{name: "session_id", value: "123456"} = Cookie.parse_from_header({"Set-Cookie", "session_id=123456; path=/"})
    assert %Cookie{name: "guest_user_id", value: "123456"} = Cookie.parse_from_header({"Set-Cookie", "guest_user_id=123456; path=/; expires=Sun, 02 Oct 2022 12:28:57 -0000"})
  end

  test "format/1 creates a string representation of the cookie" do
    assert "session_id=123456" = Cookie.format(%Cookie{name: "session_id", value: "123456"})
  end

  test "merge_lists/2 merges two cookie lists into one" do
    list_a = [%Cookie{name: "a", value: "foo"}, %Cookie{name: "b", value: "bar"}]
    list_b = [%Cookie{name: "a", value: "a"}, %Cookie{name: "c", value: "baz"}]
    result = [%Cookie{name: "a", value: "a"}, %Cookie{name: "b", value: "bar"}, %Cookie{name: "c", value: "baz"}]

    # We have to sort the resulting list in order to properly assert on the result
    merged =  Cookie.merge_lists(list_a, list_b) |> Enum.sort(&(&1.name < &2.name))

    assert ^result = merged
  end
end
