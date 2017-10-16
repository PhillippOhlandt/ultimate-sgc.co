defmodule SGCWeb.Api.DiscussionView do
  use SGCWeb, :view

  def render("index.json", %{data: data}) do
    data
  end
end
