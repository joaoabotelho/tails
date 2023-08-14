defmodule Tails.Repo.Migrations.CreateAddressesTable do
  use Ecto.Migration

  def change do
    create table(:addresses) do
      add :address, :string
      add :address_line_2, :string
      add :city, :string
      add :postal_code, :string
      add :state, :string

      timestamps()
    end
  end
end
