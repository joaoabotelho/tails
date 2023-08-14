defmodule Tails.Sitters.Sitter do
  @moduledoc """
  The sitter schema.
  """

  use Ecto.Schema

  import Ecto.Changeset
  import Tails.Changeset

  alias Tails.Users.User

  schema "sitters" do
    field :time_exp, :integer
    field :exp_description, :string

    field :pref_animals, {:array, Ecto.Enum},
      values: [:xs_dog, :s_dog, :m_dog, :l_dog, :xl_dog, :cat]

    field :job_types, {:array, Ecto.Enum}, values: [:dog_boarding, :dog_walking, :drop_in]

    field :slug, :string, autogenerate: {Ecto.UUID, :generate, []}

    belongs_to(:user, User)

    timestamps()
  end

  @doc false
  def changeset(address, attrs) do
    address
    |> cast(attrs, [
      :time_exp,
      :exp_description,
      :pref_animals,
      :job_types,
      :user_id
    ])
    |> trim([:exp_description])
    |> validate_required([:time_exp, :exp_description, :pref_animals, :job_types, :user_id])
    |> unique_constraint(:user_id)
    |> unique_constraint(:slug)
    |> validate_length(:exp_description, count: :codepoints, max: 255)
  end
end
