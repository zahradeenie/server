defmodule Server.Plugins do
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
end