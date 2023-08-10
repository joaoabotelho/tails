defmodule TailsWeb.APIAuthErrorHandler do
  @moduledoc false
  use TailsWeb, :controller
  alias Plug.Conn

  @spec call(Conn.t(), :not_authenticated) :: Conn.t()
  def call(conn, :not_authenticated) do
    conn
    |> put_status(403)
    |> json(%{error: %{code: 403, message: "Not authenticated"}})
  end
end
