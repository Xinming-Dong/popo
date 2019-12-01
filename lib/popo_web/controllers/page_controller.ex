defmodule PopoWeb.PageController do
  use PopoWeb, :controller
  
  def index(conn, %{"id" => id, "name" => name}) do
    IO.puts "**************** index page"
    IO.inspect id
    IO.inspect name
    render(conn, "index.html", id: id, name: name)
  end

  def index(conn, %{}) do
    IO.puts "**************** index page empty"
    render(conn, "index.html", id: "", name: "")
  end

  

end
