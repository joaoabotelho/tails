defmodule TailsWeb.API.V1.PetController do
  use TailsWeb, :controller
  use TailsWeb.CurrentUser

  alias Tails.Pets.Handler.Pet

  action_fallback(TailsWeb.API.V1.FallbackController)

  @doc """
  Get current user's pets info

  ## Request:

  `GET /api/v1/pets`

  """
  def index(conn, _, current_user) do
    pets = Pet.get_pets_for_user(current_user)
    render(conn, "index.json", %{pets: pets})
  end

  @doc """
  Get pets info by slug

  ## Request:

  `GET /api/v1/pets/:slug`

  """
  def show(conn, %{"slug" => pet_slug}, _) do
    pet = Pet.get_pet_by_slug(pet_slug)
    render(conn, "show.json", %{pet: pet})
  end
end
