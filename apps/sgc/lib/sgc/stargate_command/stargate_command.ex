defmodule SGC.StargateCommand do
  alias SGC.StargateCommand.Response
  alias SGC.Cookie
  alias SGC.StargateCommand.Scraper.Profile

  def get(url, headers \\ [], cookies \\ nil) do
    request(:get, url, nil, headers, cookies)
  end

  def post(url, content, headers \\ [], cookies \\ nil) do
    request(:post, url, content, headers, cookies)
  end

  defp request(method, url, content, headers, cookies) do
    options = case cookies do
      nil -> []
      cookies ->
        cookies_formatted =
          cookies
          |> filter_cookies()
          |> Enum.map(&Cookie.format/1)
          |> Enum.join("; ")
        [hackney: [cookie: [cookies_formatted]]]
    end

    headers = [{"User-Agent", "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/60.0.3112.113 Safari/537.36"} | headers]

    %HTTPoison.Response{body: body, headers: headers, status_code: status_code} = case method do
      :get -> HTTPoison.get!(url, headers, options)
      :post -> HTTPoison.post!(url, content, headers, options)
    end

    response_cookies =
      headers
      |> Enum.filter(fn
        {"Set-Cookie", _} -> true
        _ -> false
      end)
      |> Enum.map(&Cookie.parse_from_header/1)

    %Response{
      status_code: status_code,
      body: body,
      headers: headers,
      cookies: response_cookies
    }
  end

  def simple_api_get(url, cookies) do
    cookies = cookies |> filter_cookies()

    get(
      url,
      [
        {"Accept", "application/json, text/javascript, */*; q=0.01"},
        {"X-Requested-With", "XMLHttpRequest"}
      ],
      cookies
    )
  end

  def filter_cookies(cookies) do
    cookies
    |> Enum.filter(&cookie_allowed?/1)
  end

  defp cookie_allowed?(%Cookie{name: name}) when name in ["_TopFan-BCK_session", "session_id", "guest_user_id"], do: true
  defp cookie_allowed?(_), do: false

  def login(username, password) do
    %Response{body: body, cookies: cookies} = get("https://www.stargatecommand.co/home")

    [{"meta", [{"name", "csrf-token"}, {"content", csrf_token}], []}] = Floki.find(body, "meta[name=csrf-token]")

    form = ["user[user_name]": username, "user[password]": password, "utf8": "✓", "authenticity_token": csrf_token]

    %Response{body: body, cookies: new_cookies, status_code: status_code} = post(
      "https://www.stargatecommand.co/login",
      {:form, form},
      [{"Accept", "application/json"}],
      cookies
    )

    new_cookies = Cookie.merge_lists(cookies, new_cookies)

    case status_code do
      200 -> {:ok, new_cookies}
      _ -> {:error, body}
    end
  end

  def user_info(cookies) do
    cookies = cookies |> filter_cookies()

    %Response{body: body, cookies: home_cookies} = get("https://www.stargatecommand.co/home", [], cookies)

    profile_url = Floki.find(body, ".user-level") |> Floki.attribute("href") |> List.first()

    case profile_url do
      "" -> {:error, :unauthenticated}
      url -> user_info(url, home_cookies)
    end
  end
  def user_info("/profile/" <> id, cookies) do
    cookies = cookies |> filter_cookies()

    %Response{status_code: status_code, body: body, cookies: profile_cookies} = get("https://www.stargatecommand.co/profile/#{id}", [], cookies)

    case status_code do
      200 ->
        data = %{
          user_id: id,
          username: Profile.username(body),
          profile_pic: Profile.profile_pic(body),
          header_pic: Profile.header_pic(body),
          all_access: Profile.all_access?(body),
          level: Profile.level(body),
          lifetime_command_coins: Profile.lifetime_command_coins(body),
          command_coins_available: Profile.command_coins_available(body),
          posts_count: Profile.posts_count(body),
          following_count: Profile.following_count(body),
          followers_count: Profile.followers_count(body)
        }

        new_cookies = Cookie.merge_lists(cookies, profile_cookies)

        {:ok, data, new_cookies}
      404 -> {:error, :not_found}
      _ -> {:error, :unauthenticated}
    end
  end
  def user_info(id, cookies), do: user_info("/profile/#{id}", cookies)

  def user_posts(id, cookies, page \\ 1) do
    %Response{status_code: status_code, body: body, cookies: new_cookies} = simple_api_get(
      "https://www.stargatecommand.co/profile/#{id}?page=#{page}", cookies
    )

    case status_code do
      200 ->
        new_cookies = Cookie.merge_lists(cookies, new_cookies)

        {:ok, Poison.decode!(body), new_cookies}
      404 -> {:error, :not_found}
       _ -> {:error, :unauthenticated}
    end
  end

  def user_following(id, cookies, page \\ 1) do
    %Response{status_code: status_code, body: body, cookies: new_cookies} = simple_api_get(
      "https://www.stargatecommand.co/profile/#{id}/following?page=#{page}", cookies
    )

    case status_code do
      200 ->
        new_cookies = Cookie.merge_lists(cookies, new_cookies)

        {:ok, Poison.decode!(body), new_cookies}
      404 -> {:error, :not_found}
      _ -> {:error, :unauthenticated}
    end
  end

  def user_followers(id, cookies, page \\ 1) do
    %Response{status_code: status_code, body: body, cookies: new_cookies} = simple_api_get(
      "https://www.stargatecommand.co/profile/#{id}/followers?page=#{page}", cookies
    )

    case status_code do
      200 ->
        new_cookies = Cookie.merge_lists(cookies, new_cookies)

        {:ok, Poison.decode!(body), new_cookies}
      404 -> {:error, :not_found}
      _ -> {:error, :unauthenticated}
    end
  end

  def user_notifications(cookies, page \\ 1) do
    %Response{status_code: status_code, body: body, cookies: new_cookies} = simple_api_get(
      "https://www.stargatecommand.co/notifications?page=#{page}", cookies
    )

    case status_code do
      200 ->
        new_cookies = Cookie.merge_lists(cookies, new_cookies)

        {:ok, Poison.decode!(body), new_cookies}
      404 -> {:error, :not_found}
      _ -> {:error, :unauthenticated}
    end
  end

  def mark_user_notification_as_read(cookies, id) do
    %Response{status_code: status_code, cookies: new_cookies} = simple_api_get(
      "https://www.stargatecommand.co/notifications/mark_read?id=#{id}", cookies
    )

    case status_code do
      201 ->
        new_cookies = Cookie.merge_lists(cookies, new_cookies)

        {:ok, new_cookies}
      404 -> {:error, :not_found}
      _ -> {:error, :unauthenticated}
    end
  end

  def mark_all_user_notifications_as_read(cookies) do
    %Response{status_code: status_code, cookies: new_cookies} = simple_api_get(
      "https://www.stargatecommand.co/notifications/mark_all_read", cookies
    )

    case status_code do
      200 ->
        new_cookies = Cookie.merge_lists(cookies, new_cookies)

        {:ok, new_cookies}
      404 -> {:error, :not_found}
      _ -> {:error, :unauthenticated}
    end
  end
end
