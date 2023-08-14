defmodule Tails.Jobs.Job do
  @moduledoc """
  The job schema.
  """

  use Ecto.Schema

  import Ecto.Changeset
  import Tails.Changeset

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

    field :init_time, :time
    field :end_time, :time
    field :init_date, :date
    field :end_date, :date

    field :slug, :string, autogenerate: {Ecto.UUID, :generate, []}

    timestamps()
  end

  @doc false
  def changeset(address, attrs) do
    address
    |> cast(attrs, [
      :added_notes,
      :total_price,
      :type,
      :init_time,
      :end_time,
      :init_date,
      :end_date,
      :status
    ])
    |> trim([
      :added_notes
    ])
    |> validate_required([
      :total_price,
      :type,
      :init_time,
      :init_date,
      :status
    ])
    |> unique_constraint(:slug)
    |> validate_length(:added_notes, count: :codepoints, max: 255)
  end
end
