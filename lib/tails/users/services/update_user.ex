defmodule Tails.Users.Services.UpdateUser do
  @moduledoc """
  Updates a user.
  """

  alias Tails.Addresses
  alias Tails.Files.Service.UploadProfilePicture
  alias Tails.Repo
  alias Tails.Users
  alias Tails.Users.PersonalDetails
  alias Tails.Users.User

  @doc """
  Updates the user.
  """
  @personal_details_update [:age, :title, :name, :mobile_number, :emergency_contact]
  @address_update [:address, :address_line_2, :city, :postal_code, :state]

  @spec call(User.t(), map()) :: {:ok, User.t()} | {:error, any()}
  def call(user, attrs) do
    {profile_picture, attrs} = Map.pop(attrs, :profile_picture)

    Repo.transaction(fn ->
      with personal_details <- get_personal_details(user.id),
           {:ok, updated_personal_details} <-
             Users.update_personal_details(personal_details, personal_details_attrs(user, attrs)),
           {:ok, _user} <- upload_profile_picture(user, profile_picture),
           address <- Addresses.get_address(personal_details.address_id),
           {:ok, _updated_address} <- Addresses.update_address(address, address_attrs(attrs)) do
        updated_personal_details
      else
        {:error, changeset} -> Repo.rollback(changeset)
      end
    end)
  end

  defp get_personal_details(user_id) do
    case Users.get_personal_details_by_user(user_id) do
      nil -> %PersonalDetails{}
      personal_details -> personal_details
    end
  end

  defp personal_details_attrs(user, attrs) do
    attrs
    |> Map.take(@personal_details_update)
    |> Map.put_new(:user_id, user.id)
  end

  defp address_attrs(attrs) do
    attrs
    |> Map.take(@address_update)
  end

  defp upload_profile_picture(user, nil), do: {:ok, user}

  defp upload_profile_picture(user, profile_picture) do
    UploadProfilePicture.call(user, profile_picture)
  end
end
