defmodule Server.BearController do

  alias Server.Wildthings

  import Server.View, only: [render: 3]

  @templates_path Path.expand("../../templates", __DIR__)
  
  def index(conv) do
    bears =
      Wildthings.list_bears()
      |> Enum.sort(fn(b1, b2) -> b1.name <= b2.name end)

    render(conv, "index.eex", bears: bears)
  end

  def show(conv, %{"id" => id}) do
    bear = Wildthings.get_bear(id)

    render(conv, "show.eex", bear: bear)
  end

  def create(conv, %{"name" => name, "type" => type}) do
    %{conv | resp_body: "Create a #{type} bear named #{name}", status: 201}
  end

  def delete(conv, %{"id" => id}) do
    bear = Wildthings.get_bear(id)
    %{conv | resp_body: "Deleting Bear #{bear.name} is forbidden", status: 403}
  end
end