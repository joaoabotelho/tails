defmodule Tails.Users do
  @moduledoc """
  The Users context
  """
  import Ecto.Query

  alias Tails.Repo
  alias Tails.Users.User
  alias Tails.Users.PersonalDetails

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  def list_active_users do
    Repo.all(from(user in User, where: user.status == :active))
  end

  def get_user(id), do: Repo.get(User, id)

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a User.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def create_personal_details(attrs \\ %{}) do
    %PersonalDetails{}
    |> PersonalDetails.changeset(attrs)
    |> Repo.insert()
  end

  def update_personal_details(%PersonalDetails{} = personal_details, attrs) do
    personal_details
    |> PersonalDetails.changeset(attrs)
    |> Repo.update()
  end

  def get_personal_details_by_user(user_id), do: Repo.get_by(PersonalDetails, %{user_id: user_id})

  @spec fetch_user(integer(), term()) :: {:ok, User.t()} | {:error, {:not_found, String.t()}}
  def fetch_user(id, preloads \\ []) do
    query =
      from(user in User,
        where: user.id == ^id,
        preload: ^preloads
      )

    query
    |> Repo.one()
    |> Repo.normalize_one_result("User not found with id: #{id}")
  end

  def bump_user_last_sign_in_at!(%User{} = user, last_sign_in_at) do
    user
    |> User.last_sign_in_at_changeset(%{last_sign_in_at: last_sign_in_at})
    |> Repo.update!()
  end
end
