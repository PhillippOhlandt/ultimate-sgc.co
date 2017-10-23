defmodule SGC.StargateCommand.Messages.UserMessageInputTest do

  use ExUnit.Case, async: true
  alias SGC.StargateCommand.Messages.UserMessageInput

  test "text can be an empty string if image is set" do
    params = %{"text" => ""}
    assert_changeset_invalid(params)

    params = %{"text" => nil}
    assert_changeset_invalid(params)

    params = %{"text" => "", "image" => dummy_file("image/jpeg")}
    assert_changeset_valid(params)

    params = %{"text" => nil, "image" => dummy_file("image/jpeg")}
    assert_changeset_valid(params)
  end

  test "text can contain text" do
    params = %{"text" => "hello sgc"}
    assert_changeset_valid(params)
  end

  test "image can be not set" do
    params = %{"text" => "hello sgc"}
    assert_changeset_valid(params)
  end

  test "image can be nil" do
    params = %{"text" => "hello sgc", "image" => nil}
    assert_changeset_valid(params)
  end

  test "image must be a Plug.Upload struct" do
    params = %{"image" => "nah"}
    cs = assert_changeset_invalid(params)
    assert %Ecto.Changeset{errors: [image: {_, [validation: :image]}]} = cs

    params = %{
      "image" => dummy_file("image/jpeg")
    }
    assert_changeset_valid(params)
  end

  test "image must have a valid content_type" do
    params = %{"image" => dummy_file("image/jpeg")}
    assert_changeset_valid(params)

    params = %{"image" => dummy_file("image/png")}
    assert_changeset_valid(params)

    params = %{"image" => dummy_file("image/gif")}
    assert_changeset_valid(params)

    params = %{"image" => dummy_file("video/mp4")}
    cs = assert_changeset_invalid(params)
    assert %Ecto.Changeset{errors: [image: {_, [validation: :image_content_type]}]} = cs
  end

  test "request_data/1 returns multipart form data for the given message" do
    message = %UserMessageInput{text: "hello", image: nil}
    assert [{"text", "hello"}] = UserMessageInput.request_data(message)

    message = %UserMessageInput{text: "hello", image: dummy_file("image/jpeg")}
    assert [
             {"text", "hello"},
             {:file, "tmp_path/here", {"form-data", [name: "image", filename: "image.jpg"]}, ["content-type": "image/jpeg"]}
           ] = UserMessageInput.request_data(message)
  end

  ## Helpers ##

  defp assert_changeset_valid(params) do
    changeset = UserMessageInput.changeset(%UserMessageInput{}, params)
    assert changeset.valid? == true
    changeset
  end

  defp assert_changeset_invalid(params) do
    changeset = UserMessageInput.changeset(%UserMessageInput{}, params)
    assert changeset.valid? == false
    changeset
  end

  defp dummy_file(content_type) do
    %Plug.Upload{
      content_type: content_type,
      filename: "image.jpg",
      path: "tmp_path/here"
    }
  end
end
