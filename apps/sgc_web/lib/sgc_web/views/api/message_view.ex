defmodule SGCWeb.Api.MessageView do
  use SGCWeb, :view

  def render("index.json", %{data: data}) do
    data
  end
end
