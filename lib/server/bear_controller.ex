defmodule Server.BearController do
  
  def index(conv) do
    %{conv | resp_body: "Teddy, Smokey, Paddington", status: 200}
  end

  def show(conv, %{"id" => id}) do
    %{conv | resp_body: "Bear #{id}", status: 200}
  end

  def create(conv, %{"name" => name, "type" => type}) do
    %{conv | resp_body: "Create a #{type} bear named #{name}", status: 201}
  end
end