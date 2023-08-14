defmodule Tails.Repo.Migrations.AddUserInfo do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :status, :string
      add :role, :string
    end
  end
end
