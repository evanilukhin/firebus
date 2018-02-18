defmodule FirebusWeb.PageController do
  use FirebusWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
