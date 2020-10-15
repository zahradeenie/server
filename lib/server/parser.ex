defmodule Server.Parser do
  alias Server.Conv

  def parse(request) do
    [top, query_string] = String.split(request, "\n\n")

    [request_line | header_lines] = String.split(top, "\n")

    [method, path, _] = String.split(request_line, " ")

    params = parse_params(query_string)

    %Conv{
      method: method,
      path: path,
      params: params
    }
  end

  def parse_params(query_string) do
    query_string |> String.trim() |> URI.decode_query()
  end
end
