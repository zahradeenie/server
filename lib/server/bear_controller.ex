defmodule Server.BearController do

  alias Server.Wildthings
  
  def index(conv) do
    items =
      Wildthings.list_bears()
      |> Enum.filter(fn(bear) -> bear.type == "Grizzly" end)
      |> Enum.sort(fn(b1, b2) -> b1.name <= b2.name end)
      |> Enum.map(fn(bear) -> "<li>#{bear.name} - #{bear.type}</li>" end)
      |> Enum.join

    %{conv | resp_body: "<ul>#{items}</ul>", status: 200}
  end

  def show(conv, %{"id" => id}) do
    bear = Wildthings.get_bear(id)
    %{conv | resp_body: "<h1>Bear #{bear.id} - #{bear.name}</h1>", status: 200}
  end

  def create(conv, %{"name" => name, "type" => type}) do
    %{conv | resp_body: "Create a #{type} bear named #{name}", status: 201}
  end

  def delete(conv, %{"id" => id}) do
    bear = Wildthings.get_bear(id)
    %{conv | resp_body: "Deleting Bear #{bear.name} is forbidden", status: 403}
  end
end