defmodule Tails.Repo.Migrations.CreatePetsTable do
  use Ecto.Migration

  def change do
    create table(:pets) do
      add :breed, :string
      add :name, :string
      add :age, :integer
      add :castrated, :boolean
      add :trained, :boolean
      add :vaccination, :boolean
      add :sex, :string
      add :relationship_with_animals, :string
      add :special_cares, :string
      add :vet_contact, :string
      add :name_vet, :string
      add :more_about, :string
      add :microship_id, :string
      add :pet_type, :string
      add :slug, :string, default: fragment("uuid_generate_v4()"), null: false
      add :user_id, references("users", on_delete: :delete_all)

      timestamps()
    end

    create unique_index(:pets, [:slug])
  end
end
