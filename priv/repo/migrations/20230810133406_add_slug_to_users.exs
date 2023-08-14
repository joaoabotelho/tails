defmodule Tails.Repo.Migrations.AddSlugToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :slug, :string, default: fragment("uuid_generate_v4()"), null: false
      add :unconfirmed_email, :string
      add :email_confirmation_token, :string
      add :email_confirmed_at, :utc_datetime
      add :password_changed_at, :utc_datetime
      add :last_sign_in_at, :utc_datetime
    end

    create unique_index(:users, [:slug])
  end
end
