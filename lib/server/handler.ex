defmodule Server.Handler do
  @pages_path Path.expand("../..pages", __DIR__)

  alias Server.Conv

  import Server.Plugins, only: [rewrite_path: 1, track: 1]
  import Server.Parser, only: [parse: 1]

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

  def route(%Conv{method: "GET", path: "/wildthings"} = conv) do
    %{conv | resp_body: "Bears, Lions, Tigers", status: 200}
  end

  def route(%Conv{method: "GET", path: "/bears"} = conv) do
    %{conv | resp_body: "Teddy, Smokey, Paddington", status: 200}
  end

  def route(%Conv{method: "GET", path: "/bears/" <> id} = conv) do
    %{conv | resp_body: "Bear #{id}", status: 200}
  end

  def route(%Conv{method: "DELETE", path: "/bears/" <> id} = conv) do
    %{conv | resp_body: "Deleting Bear #{id} is forbidden", status: 403}
  end

  def route(%Conv{method: "GET", path: "/about"} = conv) do
    @pages_path
    |> Path.join("about.html")
    |> File.read()
    |> handle_file(conv)
  end

  def route(%Conv{method: "GET", path: "/bears/new"} = conv) do
    Path.expand("../..pages", __DIR__)
    |> Path.join("form.html")
    |> File.read()
    |> handle_file(conv)
  end

  def route(%Conv{method: "GET", path: "/pages/" <> file} = conv) do
    Path.expand("../..pages", __DIR__)
    |> Path.join(file <> "html")
    |> File.read()
    |> handle_file(conv)
  end

  def route(%Conv{path: path} = conv) do
    %{conv | resp_body: "No #{path} here", status: 404}
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

  def format_response(%Conv{} = conv) do
    """
    HTTP/1.1 #{Conv.full_status(conv)}
    Content-Type: text/html
    Content-Length: #{String.length(conv.resp_body)}

    #{conv.resp_body}
    """
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
