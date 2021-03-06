defmodule Server.Plugins do
  alias Server.Conv

  def track(%Conv{status: 404, path: path} = conv) do
    IO.puts("Warning #{path} is not found")
    conv
  end

  def track(%Conv{} = conv), do: conv

  def rewrite_path(%Conv{path: "wildlife"} = conv) do
    %{conv | path: "/wildthings"}
  end

  def rewrite_path(%Conv{path: "/bears?id=" <> id} = conv) do
    %{conv | path: "/bears/#{id}"}
  end

  def rewrite_path(%Conv{} = conv), do: conv
end
