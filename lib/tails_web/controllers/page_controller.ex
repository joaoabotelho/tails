defmodule TailsWeb.PageController do
  use TailsWeb, :controller

  def index(conn, _params) do
    json(conn, :ok)
  end
end
