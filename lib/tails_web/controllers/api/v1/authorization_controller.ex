defmodule TailsWeb.API.V1.AuthorizationController do
  use TailsWeb, :controller

  alias Plug.Conn
  alias PowAssent.Plug

  action_fallback(TailsWeb.API.V1.FallbackController)

  @spec new(Conn.t(), map()) :: Conn.t()
  def new(conn, %{"provider" => provider}) do
    conn
    |> Plug.authorize_url(provider, redirect_uri(conn))
    |> case do
      {:ok, url, conn} ->
        json(conn, %{url: url, session_params: conn.private[:pow_assent_session_params]})

      {:error, _error, conn} ->
        conn
        |> put_status(500)
        |> json(%{error: %{status: 500, message: "An unexpected error occurred"}})
    end
  end

  defp redirect_uri(_conn) do
    Application.get_env(:tails, :client_link) <> "/login/callback"
  end

  @spec callback(Conn.t(), map()) :: Conn.t()
  def callback(conn, %{"provider" => provider} = params) do
    case Map.fetch(params, "session_params") do
      {:ok, session_params} ->
        params = Map.drop(params, ["provider", "session_params"])

        conn
        |> Conn.put_private(:pow_assent_session_params, session_params)
        |> Plug.callback_upsert(provider, params, redirect_uri(conn))
        |> case do
          {:ok, conn} ->
            conn
            |> put_resp_cookie("renewal_token", conn.private.api_renewal_token)
            |> json(%{
              access_token: conn.private.api_access_token,
              user_status: conn.assigns.current_user.status
            })

          {:error, conn} ->
            conn
            |> put_status(500)
            |> json(%{error: %{status: 500, message: "An unexpected error occurred"}})
        end

      :error ->
        {:error, {:bad_request, "Missing session params"}}
    end
  end
end
