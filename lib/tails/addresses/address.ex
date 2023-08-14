defmodule Tails.Addresses.Address do
  @moduledoc """
  The address schema.
  """

  use Ecto.Schema

  import Ecto.Changeset
  import Tails.Changeset

  alias Tails.Users.PersonalDetails

  schema "addresses" do
    field(:address, :string, redact: true)
    field(:address_line_2, :string, redact: true)
    field(:city, :string, redact: true)
    field(:postal_code, :string, redact: true)
    field(:state, :string, redact: true)

    has_one(:personal_details, PersonalDetails)

    timestamps()
  end

  @doc false
  def changeset(address, attrs) do
    address
    |> cast(attrs, [
      :address,
      :address_line_2,
      :city,
      :postal_code,
      :state
    ])
    |> trim([:address, :address_line_2, :city, :postal_code, :state])
    |> validate_required([:address, :postal_code])
    |> changeset_validate_lengths()
  end

  defp changeset_validate_lengths(changeset) do
    changeset
    |> validate_length(:address, count: :codepoints, max: 255)
    |> validate_length(:address_line_2, count: :codepoints, max: 255)
    |> validate_length(:city, count: :codepoints, max: 255)
    |> validate_length(:state, count: :codepoints, max: 255)
    |> validate_length(:postal_code, count: :codepoints, max: 255)
  end
end
