defmodule Tails.Users.User do
  @moduledoc false
  use Ecto.Schema

  use Pow.Ecto.Schema,
    password_hash_methods: {&Argon2.hash_pwd_salt/1, &Argon2.verify_pass/2},
    password_min_length: 14

  use Pow.Extension.Ecto.Schema,
    extensions: [PowEmailConfirmation]

  use PowAssent.Ecto.Schema

  import Pow.Ecto.Schema.Changeset,
    only: [new_password_changeset: 3]

  import Ecto.Changeset
  import Tails.Changeset

  alias Tails.Pets.Pet
  alias Tails.Sitters.Sitter
  alias Tails.Users.PersonalDetails

  schema "users" do
    field :unconfirmed_email, :string, redact: true

    field :status, Ecto.Enum,
      values: [:initiated, :active, :cancelled, :deleted, :inactive],
      default: :initiated

    field :role, Ecto.Enum,
      values: [:sitter, :admin, :client],
      default: :client

    field :slug, :string, autogenerate: {Ecto.UUID, :generate, []}
    field :last_sign_in_at, :utc_datetime, redact: true
    field :password_changed_at, :utc_datetime, redact: true

    field(:profile_picture, :string, redact: true)

    pow_user_fields()

    has_one(:personal_details, PersonalDetails)
    has_one(:sitter, Sitter, foreign_key: :user_id, where: [role: :sitter])

    has_many(:pets, Pet, foreign_key: :user_id, where: [role: :client])

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [
      :email,
      :unconfirmed_email,
      :email_confirmed_at,
      :password,
      :password_changed_at,
      :status,
      :role,
      :profile_picture
    ])
    |> trim([:email, :profile_picture])
    |> validate_required([:email])
    |> pow_extension_changeset(attrs)
    |> validate_email(attrs)
    |> validate_strong_password()
    |> new_password_changeset(attrs, @pow_config)
    |> changeset_validate_lengths()
    |> changeset_unique_constraints()
  end

  # validates the user_id field which by default is :email
  # suppress pow_user_id_field_changeset validation if email is invalid
  defp validate_email(%{valid?: false} = changeset, attrs) do
    changeset.errors
    |> Enum.find(fn
      {:email, _reason} -> true
      _error -> false
    end)
    |> case do
      nil -> pow_user_id_field_changeset(changeset, attrs)
      _email_error -> changeset
    end
  end

  defp validate_email(changeset, attrs), do: pow_user_id_field_changeset(changeset, attrs)

  def validate_strong_password(user) do
    user
    # has a number
    |> validate_format(:password, ~r/[0-9]+/, message: "Password must contain a number")
    # has an upper case letter
    |> validate_format(:password, ~r/[A-Z]+/,
      message: "Password must contain an upper-case letter"
    )
    # has a lower case letter
    |> validate_format(:password, ~r/[a-z]+/,
      message: "Password must contain a lower-case letter"
    )
  end

  defp changeset_validate_lengths(changeset) do
    changeset
    |> validate_length(:email, count: :codepoints, max: 255)
  end

  defp changeset_unique_constraints(changeset) do
    changeset
    |> unique_constraint(:email)
    |> unique_constraint(:slug)
  end

  def pow_assent_user_identity_changeset(user, %{"email" => _email_params}, _opts) do
    user
    |> cast_assoc(:user_identities, with: &Tails.UserIdentities.UserIdentity.changeset/2)
    |> validate_required(:user_identities)
    |> unique_constraint(:email)
  end

  def last_sign_in_at_changeset(user, attrs) do
    user
    |> cast(attrs, [:last_sign_in_at])
    |> validate_required(:last_sign_in_at)
  end
end
