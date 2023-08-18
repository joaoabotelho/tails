defmodule TailsWeb.PageController do
  use TailsWeb, :controller

  def index(conn, _params) do
    conn |> redirect(to: "/app") |> halt()
  end
end
