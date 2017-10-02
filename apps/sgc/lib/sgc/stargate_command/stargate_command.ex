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

    %HTTPoison.Response{body: body, headers: headers} = case method do
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
      body: body,
      headers: headers,
      cookies: response_cookies
    }
  end
end
