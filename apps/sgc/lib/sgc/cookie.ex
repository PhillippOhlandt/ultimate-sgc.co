defmodule SGC.Cookie do
  defstruct name: "",
            value: ""

  def parse_from_header({"Set-Cookie", cookie_string}) do
    [name_value | _] = String.split(cookie_string, ";")
    [name, value] = String.split(name_value, "=", parts: 2)

    %__MODULE__{name: name, value: value}
  end

  def format(%__MODULE__{name: name, value: value}) do
    name <> "=" <> value
  end

  def merge_lists(list_a, list_b) do
    list_b
    |> Enum.concat(list_a)
    |> Enum.uniq_by(fn cookie -> cookie.name end)
  end
end
