defmodule Tails.Pets.Handler.Pet do
  @moduledoc """
  Handler for Pet
  """

  alias Tails.Service.SanitizeParams
  alias Tails.Pets.Pets

  def get_pets_for_user(user), do: Pets.get_pets_for_user_id(user.id)
end
