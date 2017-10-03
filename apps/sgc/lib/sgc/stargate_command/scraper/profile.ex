defmodule SGC.StargateCommand.Scraper.Profile do

  def username(body) do
    body
    |> Floki.find(".banner-area .profile-pic figcaption")
    |> Floki.text()
    |> String.trim()
    |> String.split("\n")
    |> Enum.at(0)
    |> String.trim()
  end

  def profile_pic(body) do
    body
    |> Floki.find(".banner-area .profile-pic figure img")
    |> Floki.attribute("src")
    |> List.first()
    |> String.trim()
  end

  def level(body) do
    body
    |> Floki.find(".banner-area .profile-pic .status .set")
    |> List.first()
    |> Floki.find("h2 .access-level-text")
    |> Floki.text()
    |> String.trim()
  end

  def lifetime_command_coins(body) do
    body
    |> Floki.find(".banner-area .profile-pic .status .set")
    |> List.first()
    |> Floki.find("h2 .life-coin-text")
    |> Floki.text()
    |> String.trim()
  end

  def command_coins_available(body) do
    body
    |> Floki.find(".banner-area .profile-pic .status .set")
    |> Enum.at(1)
    |> Floki.find("h2 .coins-balance-text")
    |> Floki.text()
    |> String.trim()
  end

  def posts_count(body) do
    body
    |> Floki.find("#selected_profile_user .set-list .set")
    |> Enum.at(0)
    |> Floki.find("a")
    |> Floki.text()
    |> String.replace("Posts", "")
  end

  def following_count(body) do
    body
    |> Floki.find("#selected_profile_user .set-list .set")
    |> Enum.at(1)
    |> Floki.find("a #following_count_text")
    |> Floki.text()
  end

  def followers_count(body) do
    body
    |> Floki.find("#selected_profile_user .set-list .set")
    |> Enum.at(2)
    |> Floki.find("a #follower_count_text")
    |> Floki.text()
  end
end
