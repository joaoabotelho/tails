defmodule Tails.Repo.Migrations.CreateJobsTable do
  use Ecto.Migration

  def change do
    create table(:jobs) do
      add :added_notes, :string
      add :total_price, :float
      add :service_type, :string
      add :init_time, :time
      add :end_time, :time
      add :init_date, :date
      add :end_date, :date
      add :status, :string
      add :slug, :string, default: fragment("uuid_generate_v4()"), null: false

      timestamps()
    end
  end

  create unique_index(:jobs, [:slug])
end
