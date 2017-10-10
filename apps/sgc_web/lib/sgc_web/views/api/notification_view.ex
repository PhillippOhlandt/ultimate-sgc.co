defmodule SGCWeb.Api.NotificationView do
  use SGCWeb, :view

  def render("index.json", %{data: data}) do
    data
  end

  def render("mark_read.json", _) do
    %{}
  end
end
