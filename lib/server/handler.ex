defmodule Server.Handler do
  def handle(request) do
    request
    |> parse
    |> rewrite_path
    |> IO.inspect()
    |> route
    |> emojify
    |> track
    |> format_response
  end

  def emojify(%{status: 200} = conv) do
    emojie = String.duplicate("✅", 3)
    body = emojie <> "\n" <> conv.resp_body <> "\n" <> emojie

    %{conv | resp_body: body}
  end

  def emojify(conv), do: conv

  def track(%{status: 404, path: path} = conv) do
    IO.puts("Warning #{path} is not found")
    conv
  end

  def track(conv), do: conv

  def rewrite_path(%{path: "wildlife"} = conv) do
    %{conv | path: "/wildthings"}
  end

  def rewrite_path(%{path: "/bears?id=" <> id} = conv) do
    %{conv | path: "/bears/#{id}"}
  end

  def rewrite_path(conv), do: conv

  def parse(request) do
    [method, path, _] =
      request
      |> String.split("\n")
      |> List.first()
      |> String.split(" ")

    %{
      method: method,
      path: path,
      resp_body: "",
      status: nil
    }
  end

  def route(%{method: "GET", path: "/wildthings"} = conv) do
    %{conv | resp_body: "Bears, Lions, Tigers", status: 200}
  end

  def route(%{method: "GET", path: "/bears"} = conv) do
    %{conv | resp_body: "Teddy, Smokey, Paddington", status: 200}
  end

  def route(%{method: "GET", path: "/bears/" <> id} = conv) do
    %{conv | resp_body: "Bear #{id}", status: 200}
  end

  def route(%{method: "DELETE", path: "/bears/" <> id} = conv) do
    %{conv | resp_body: "Deleting Bear #{id} is forbidden", status: 403}
  end

  def route(%{method: "GET", path: "/about"} = conv) do
    Path.expand("../..pages", __DIR__)
    |> Path.join("about.html") 
    |> File.read
    |> handle_file(conv)
  end

  def route(%{method: "GET", path: "/bears/new"} = conv) do
    Path.expand("../..pages", __DIR__)
    |> Path.join("form.html") 
    |> File.read
    |> handle_file(conv)
  end

  def route(%{method: "GET", path: "/pages/" <> page} = conv) do
    Path.expand("../..pages", __DIR__)
    |> Path.join(file <> "html") 
    |> File.read
    |> handle_file(conv)
  end

  def handle_file({:ok, content}, conv) do
    %{conv | resp_body: content, status: 200}
  end

  def handle_file({:error, :enoent}, conv) do
    %{conv | resp_body: "File not found", status: 404}
  end

  def handle_file({:error, reason}, conv) do
    %{conv | resp_body: "File error #{reason}", status: 500}
  end

  def route(%{path: path} = conv) do
    %{conv | resp_body: "No #{path} here", status: 404}
  end

  def format_response(conv) do
    """
    HTTP/1.1 #{conv.status} #{status_reason(conv.status)}
    Content-Type: text/html
    Content-Length: #{String.length(conv.resp_body)}

    #{conv.resp_body}
    """
  end

  defp status_reason(code) do
    %{
      200 => "OK",
      201 => "Created",
      401 => "Unauthorized",
      403 => "Forbidden",
      404 => "Not Found",
      500 => "Internal Server Error"
    }[code]
  end
end

request = """
GET /wildthings HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Server.Handler.handle(request)
IO.puts(response)

request = """
GET /wildlife HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Server.Handler.handle(request)
IO.puts(response)

request = """
GET /bears HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Server.Handler.handle(request)
IO.puts(response)

request = """
GET /bears/new HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Server.Handler.handle(request)
IO.puts(response)

request = """
GET /bears/1 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Server.Handler.handle(request)
IO.puts(response)

request = """
DELETE /bears/1 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Server.Handler.handle(request)
IO.puts(response)

request = """
GET /bigfoot HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Server.Handler.handle(request)
IO.puts(response)
