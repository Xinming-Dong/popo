defmodule PopoWeb.PageController do
  use PopoWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
