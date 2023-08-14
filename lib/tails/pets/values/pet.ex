defmodule Tails.Pets.Values.Pet do
  @moduledoc false

  alias Tails.Pets.Pet

  def build(pet) when is_list(pet),
    do: Enum.map(pet, &build/1)

  def build(%Pet{} = pet) do
    %{
      name: pet.name,
      age: pet.age,
      breed: pet.breed,
      castrated: pet.castrated,
      trained: pet.trained,
      vaccination: pet.vaccination,
      sex: pet.sex,
      relationship_with_animals: pet.relationship_with_animals,
      special_cares: pet.special_cares,
      vet_contact: pet.vet_contact,
      vet_name: pet.vet_name,
      more_about: pet.more_about,
      microship_id: pet.microship_id,
      type: pet.type,
      slug: pet.slug,
    }
  end
end
