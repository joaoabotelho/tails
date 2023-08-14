defmodule Tails.Repo.Migrations.CreatePersonalInfoTable do
  use Ecto.Migration

  def change do
    create table(:personal_details) do
      add :name, :string
      add :age, :integer
      add :mobile_number, :string
      add :emergency_contact, :string
      add :title, :string
      add :slug, :string, default: fragment("uuid_generate_v4()"), null: false
      add :user_id, references(:users, on_delete: :nothing), null: false
      add :address_id, references(:addresses, on_delete: :nothing), null: true

      timestamps()
    end

    create unique_index(:personal_details, [:slug])
    create unique_index(:personal_details, [:user_id])
  end
end
