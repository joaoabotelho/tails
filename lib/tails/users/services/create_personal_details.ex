defmodule Tails.Users.Services.CreatePersonalDetails do
  @moduledoc """
  Creates personal details for user.
  """

  alias Tails.Addresses
  alias Tails.Files.Service.UploadProfilePicture
  alias Tails.Repo
  alias Tails.Users
  alias Tails.Users.User

  @doc """
  Creates personal details for user.
  """
  @personal_details_update [:title, :name, :mobile_number, :emergency_contact]
  @address_update [:address, :address_line_2, :city, :postal_code, :state]

  @spec call(User.t(), map()) :: {:ok, User.t()} | {:error, any()}
  def call(user, attrs) do
    {profile_picture, attrs} = Map.pop(attrs, :profile_picture)

    Repo.transaction(fn ->
      with address_attrs <- address_attrs(attrs),
           {:ok, address} <- Addresses.create_address(address_attrs),
           {:ok, user} <- upload_profile_picture(user, profile_picture),
           personal_details_attrs <- personal_details_attrs(user, address, attrs),
           {:ok, _personal_details} <- Users.create_personal_details(personal_details_attrs) do
            user
      else
        {:error, changeset} -> Repo.rollback(changeset)
      end
    end)
  end

  defp personal_details_attrs(user, address, attrs) do
    attrs
    |> Map.take(@personal_details_update)
    |> Map.put_new(:user_id, user.id)
    |> Map.put_new(:address_id, address.id)
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
