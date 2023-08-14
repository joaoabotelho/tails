defmodule Tails.Users.PersonalDetails do
  @moduledoc false
  use Ecto.Schema

  import Ecto.Changeset
  import Tails.Changeset

  alias Tails.Users.User

  schema "personal_details" do
    field :name, :string, redact: true
    field :age, :integer
    field :mobile_number, :string, redact: true
    field :emergency_contact, :string, redact: true
    field :title, Ecto.Enum, values: [:mr, :mrs, :miss, :ms, :mx]
    field :slug, :string, autogenerate: {Ecto.UUID, :generate, []}

    belongs_to(:user, User)
    belongs_to(:address, Address)

    timestamps()
  end

  @doc false
  def changeset(personal_details, attrs, required \\ [:user_id]) do
    personal_details
    |> cast(attrs, [
      :address_id,
      :name,
      :age,
      :mobile_number,
      :emergency_contact,
      :title,
      :user_id
    ])
    |> trim([:mobile_number, :name, :emergency_contact])
    |> validate_required(required)
    |> unique_constraint(:user_id)
    |> unique_constraint(:slug)
    |> validate_length(:mobile_number, count: :codepoints, max: 255)
    |> validate_length(:emergency_contact, count: :codepoints, max: 255)
  end
end
