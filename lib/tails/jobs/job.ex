defmodule Tails.Jobs.Job do
  @moduledoc """
  The job schema.
  """

  use Ecto.Schema

  import Ecto.Changeset
  import Tails.Changeset

  alias Tails.Repo
  alias Tails.Users.User
  alias Tails.Sitters.Sitter

  schema "jobs" do
    field :added_notes, :string
    field :total_price, :float

    field :type, Ecto.Enum, values: [:dog_boarding, :dog_walking, :drop_in]

    field :status, Ecto.Enum,
      values: [
        :pendent,
        :confirmed,
        :payment_missing,
        :refused,
        :expired,
        :in_progress,
        :canceled,
        :completed
      ],
      default: :pendent

    field :init_at, :utc_datetime
    field :end_at, :utc_datetime

    field :slug, :string, autogenerate: {Ecto.UUID, :generate, []}

    belongs_to :client, User, where: [role: :client]
    belongs_to :sitter, Sitter

    timestamps()
  end

  @doc false
  def changeset(address, attrs) do
    address
    |> cast(attrs, [
      :client_id,
      :sitter_id,
      :added_notes,
      :total_price,
      :type,
      :init_at,
      :end_at,
      :status
    ])
    |> trim([
      :added_notes
    ])
    |> validate_required([
      :client_id,
      :total_price,
      :type,
      :init_at,
      :status
    ])
    |> unique_constraint(:slug)
    |> validate_length(:added_notes, count: :codepoints, max: 255)
    |> client_must_be_client_role()
  end

  defp client_must_be_client_role(changeset) do
    client_id = get_field(changeset, :client_id)

    case Repo.get(User, client_id) do
      nil ->
        changeset
        |> cast_assoc(:client, required: true)
        |> add_error(:client_id, "Client not found")

      %{role: :client} ->
        changeset

      _ ->
        changeset
        |> cast_assoc(:client, required: true)
        |> add_error(:client_id, "Client must have the 'client' role")
    end
  end
end
