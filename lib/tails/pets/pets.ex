defmodule Tails.Pets.Pets do
  @moduledoc """
  The Pets context
  """

  import Ecto.Query

  alias Tails.Repo
  alias Tails.Pets.Pet

  @doc """
  Returns the list of pets.

  ## Examples

      iex> list_pets()
      [%Pet{}, ...]

  """
  def list_pets do
    Repo.all(Pet)
  end

  def get_pet(id), do: Repo.get(Pet, id)

  @spec get_pet_by_slug(String.t()) :: Pet.t() | nil
  def get_pet_by_slug(slug), do: Pet |> Repo.get_by(%{slug: slug})

  def create_pet(attrs \\ %{}) do
    %Pet{}
    |> Pet.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a Pet.

  ## Examples

      iex> update_pet(pet, %{field: new_value})
      {:ok, %Pet{}}

      iex> update_pet(pet, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_pet(%Pet{} = pet, attrs) do
    pet
    |> Pet.changeset(attrs)
    |> Repo.update()
  end

  def get_pets_for_user_id(user_id),
    do: Repo.all(from(pet in Pet, where: pet.user_id == ^user_id))
end
