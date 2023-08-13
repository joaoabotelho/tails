defmodule Tails.Repo.Migrations.AddUserInfo do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :name, :string, null: true
      add :status, :string
      add :role, :string
    end
  end
end
