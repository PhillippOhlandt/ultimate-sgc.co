defmodule SGCWeb.PostView do
  use SGCWeb, :view

  def render("posts.json", %{data: data}) do
    data
  end
end
