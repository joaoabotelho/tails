defmodule TailsWeb.API.V1.RegistrationController do
  use TailsWeb, :controller

  alias Ecto.Changeset
  alias Plug.Conn
  alias Tails.Auth.Services.SendEmailConfirmationEmail
  alias TailsWeb.ErrorHelpers

  @spec create(Conn.t(), map()) :: Conn.t()
  def create(conn, %{"user" => user_params}) do
    conn
    |> Pow.Plug.create_user(user_params)
    |> case do
      {:ok, user, conn} ->
        SendEmailConfirmationEmail.call(user)

        conn
        |> put_resp_cookie("renewal_token", conn.private.api_renewal_token)
        |> json(%{
          access_token: conn.private.api_access_token,
          user_status: user.status
        })

      {:error, changeset, conn} ->
        errors = Changeset.traverse_errors(changeset, &ErrorHelpers.translate_error/1)

        conn
        |> put_status(500)
        |> json(%{error: %{status: 500, message: "Couldn't create user", errors: errors}})
    end
  end
end
