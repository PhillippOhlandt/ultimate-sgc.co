defmodule SGC.StargateCommandTest do

  use ExUnit.Case, async: true
  alias SGC.StargateCommand
  alias SGC.Cookie
  alias SGC.StargateCommand.Messages.UserMessageInput

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

  test "validate_user_message_input/1 returns {:ok, message} with valid params" do
    params = %{
      "text" => "hello",
      "image" => %Plug.Upload{
        content_type: "image/jpeg",
        filename: "image.jpg",
        path: "tmp_path/here"
      }
    }

    assert {:ok, %UserMessageInput{}} = StargateCommand.validate_user_message_input(params)
  end

  test "validate_user_message_input/1 returns {:error, changeset} with invalid params" do
    params = %{
      "text" => "hello",
      "image" => %Plug.Upload{
        content_type: "video/mp4", # wrong content type
        filename: "image.jpg",
        path: "tmp_path/here"
      }
    }

    assert {:error, %Ecto.Changeset{}} = StargateCommand.validate_user_message_input(params)
  end
end
