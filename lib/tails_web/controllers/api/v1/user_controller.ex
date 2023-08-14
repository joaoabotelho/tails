defmodule TailsWeb.API.V1.UserController do
  use TailsWeb, :controller
  use TailsWeb.CurrentUser

  alias Tails.Users.Handler.User

  action_fallback(TailsWeb.API.V1.FallbackController)

  plug :reload_user

  @doc """
  Get current user profile info

  ## Request:

  `GET /api/v1/user`

  Response 200:

    {
      "email": "email@email.com",
      "name": "John",
      "status": "active",
    }

  """
  def show(conn, _, current_user) do
    with {:ok, user} <- User.get_personal_details_for_user(current_user) do
      render(conn, "show.json", %{user: user})
    end
  end

  @doc """
  Completes fields for user after successfull register

  ## Request:

  `POST /api/v1/user/complete_profile`

  Params:
    * name

  Response 200:

  {
    "data": {
        "status": "ok"
    }
  }

  """
  def complete_profile(conn, params, current_user) do
    with {:ok, _user} <- User.complete_profile(current_user, params) do
      render(conn, "success.json")
    end
  end

  defp reload_user(conn, _opts) do
    config = Pow.Plug.fetch_config(conn)
    user = Pow.Plug.current_user(conn, config)
    reloaded_user = Tails.Repo.get!(Tails.Users.User, user.id)

    Pow.Plug.assign_current_user(conn, reloaded_user, config)
  end
end
