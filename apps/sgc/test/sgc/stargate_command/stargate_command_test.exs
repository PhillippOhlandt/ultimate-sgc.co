defmodule SGC.StargateCommandTest do

  use ExUnit.Case, async: true
  alias SGC.StargateCommand
  alias SGC.Cookie

  test "filter_cookies/1 only keeps whitelisted cookies" do
    input = [
      %Cookie{name: "_TopFan-BCK_session"},
      %Cookie{name: "session_id"},
      %Cookie{name: "guest_user_id"},
      %Cookie{name: "_sgc_web_key"}
    ]

    output = [
      %Cookie{name: "_TopFan-BCK_session"},
      %Cookie{name: "session_id"},
      %Cookie{name: "guest_user_id"}
    ]

    assert ^output = StargateCommand.filter_cookies(input)
  end
end
