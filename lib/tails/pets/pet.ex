defmodule Tails.Pets.Pet do
  @moduledoc """
  The pet schema.
  """

  use Ecto.Schema

  import Ecto.Changeset
  import Tails.Changeset

  alias Tails.Users.User

  schema "pets" do
    field :breed, :string
    field :name, :string
    field :age, :integer
    field :castrated, :boolean
    field :trained, :boolean
    field :vaccination, :boolean

    field :sex, Ecto.Enum, values: [:male, :female]
    field :relationship_with_animals, :string
    field :special_cares, :string
    field :vet_contact, :string
    field :name_vet, :string
    field :more_about, :string
    field :microship_id, :string
    field :pet_type, Ecto.Enum, values: [:xs_dog, :s_dog, :m_dog, :l_dog, :xl_dog, :cat]

    field :slug, :string, autogenerate: {Ecto.UUID, :generate, []}

    belongs_to(:user, User)

    timestamps()
  end

  @doc false
  def changeset(address, attrs) do
    address
    |> cast(attrs, [
      :breed,
      :name,
      :age,
      :castrated,
      :trained,
      :vaccination,
      :sex,
      :relationship_with_animals,
      :special_cares,
      :vet_contact,
      :name_vet,
      :more_about,
      :microship_id,
      :pet_type,
      :user_id
    ])
    |> trim([
      :breed,
      :name,
      :relationship_with_animals,
      :special_cares,
      :vet_contact,
      :name_vet,
      :more_about,
      :microship_id
    ])
    |> validate_required([
      :breed,
      :name,
      :age,
      :castrated,
      :trained,
      :vaccination,
      :sex,
      :vet_contact,
      :name_vet,
      :microship_id,
      :pet_type,
      :user_id
    ])
    |> unique_constraint(:slug)
    |> changeset_validate_lengths()
  end

  defp changeset_validate_lengths(changeset) do
    changeset
    |> validate_length(:breed, count: :codepoints, max: 255)
    |> validate_length(:name, count: :codepoints, max: 255)
    |> validate_length(:relationship_with_animals, count: :codepoints, max: 255)
    |> validate_length(:special_cares, count: :codepoints, max: 255)
    |> validate_length(:vet_contact, count: :codepoints, max: 255)
    |> validate_length(:name_vet, count: :codepoints, max: 255)
    |> validate_length(:more_about, count: :codepoints, max: 255)
    |> validate_length(:microship_id, count: :codepoints, max: 255)
  end
end
