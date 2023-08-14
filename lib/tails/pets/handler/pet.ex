defmodule Tails.Pets.Handler.Pet do
  @moduledoc """
  Handler for Pet
  """

  alias Tails.Pets.Pets

  def get_pets_for_user(user), do: Pets.get_pets_for_user_id(user.id)

  def get_pet_by_slug(slug), do: Pets.get_pet_by_slug(slug)
end
