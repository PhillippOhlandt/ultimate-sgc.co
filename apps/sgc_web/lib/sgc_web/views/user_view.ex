defmodule SGCWeb.UserView do
  use SGCWeb, :view

  def render("following.json", %{data: data}) do
    data
  end

  def render("followers.json", %{data: data}) do
    data
  end
end
