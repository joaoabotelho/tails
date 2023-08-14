defmodule TailsWeb.API.V1.PetView do
  use TailsWeb, :view

  alias Tails.Pets.Values.Pet

  def render("show.json", %{pets: pets}) do
    Pet.build(pets)
  end
end
