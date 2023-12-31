defmodule TailsWeb.API.V1.PetView do
  use TailsWeb, :view

  alias Tails.Pets.Values.Pet

  def render("show.json", %{pet: pet}) do
    Pet.build(pet)
  end

  def render("index.json", %{pets: pets}) do
    Pet.build(pets)
  end
end
