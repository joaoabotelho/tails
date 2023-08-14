defmodule Tails.Repo.Migrations.CreateSittersTable do
  use Ecto.Migration

  def change do
    create table(:sitters) do
      add :time_exp, :integer
      add :exp_description, :string
      add :job_types, {:array, :string}, default: []
      add :pref_animals, {:array, :string}, default: []
      add :slug, :string, default: fragment("uuid_generate_v4()"), null: false
      add :user_id, references(:users, on_delete: :nothing), null: false

      timestamps()
    end

    create unique_index(:sitters, [:slug])
    create unique_index(:sitters, [:user_id])
  end
end
