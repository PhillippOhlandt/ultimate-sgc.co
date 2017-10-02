defmodule SGC.StargateCommand do
  alias SGC.StargateCommand.Response
  alias SGC.Cookie

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
          |> Enum.map(&Cookie.format/1)
          |> Enum.join("; ")
        [hackney: [cookie: [cookies_formatted]]]
    end

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
end
