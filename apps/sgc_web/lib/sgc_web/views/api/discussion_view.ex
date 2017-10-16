defmodule SGCWeb.Api.DiscussionView do
  use SGCWeb, :view

  def render("index.json", %{data: data}) do
    data
  end

  def render("mark_all_read.json", _) do
    %{}
  end
end
