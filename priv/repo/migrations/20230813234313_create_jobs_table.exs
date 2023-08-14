defmodule Tails.Repo.Migrations.CreateJobsTable do
  use Ecto.Migration

  def change do
    create table(:jobs) do
      add :added_notes, :string
      add :total_price, :float
      add :type, :string
      add :init_at, :utc_datetime
      add :end_at, :time
      add :status, :string
      add :slug, :string, default: fragment("uuid_generate_v4()"), null: false

      add :client_id, references("users", on_delete: :delete_all)
      add :sitter_id, references("sitters", on_delete: :nothing)

      timestamps()
    end

    create unique_index(:jobs, [:slug])
  end
end
