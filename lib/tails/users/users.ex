defmodule Tails.Users.Users do
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
end
