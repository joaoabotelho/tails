defmodule TailsWeb.API.V1.PetController do
  use TailsWeb, :controller
  use TailsWeb.CurrentUser

  alias Tails.Pets.Handler.Pet

  action_fallback(TailsWeb.API.V1.FallbackController)

  @doc """
  Get current user's pets info

  ## Request:

  `GET /api/v1/pets`

  Response 200:

    {
      "email": "email@email.com",
      "name": "John",
      "status": "active",
    }

  """
  def show(conn, _, current_user) do
    pets = Pet.get_pets_for_user(current_user)
    render(conn, "show.json", %{pets: pets})
  end
end
