defmodule Tails.Users.Handler.User do
  @moduledoc """
  Handler for User
  """

  alias Tails.Service.SanitizeParams
  alias Tails.Users.Services.UpdateUser
  alias Tails.Users.Services.CreatePersonalDetails
  alias Tails.Users

  @update_user_attrs [
    "name",
    "mobile_number",
    "emergency_contact",
    "title",
    "address",
    "address_line_2",
    "city",
    "postal_code",
    "state",
    "profile_picture"
  ]

  def complete_profile(%{status: :initiated} = user, params) do
    attrs = SanitizeParams.call(params, @update_user_attrs)
    with {:ok, user} <- CreatePersonalDetails.call(user, attrs) do
      Users.update_user(user, %{status: :active})
    end
  end

  def complete_profile(_, _), do: {:error, 422, "user already active"}

  def get_personal_details_for_user(user),
    do: Users.fetch_user(user.id, personal_details: [:address])

  def update_last_sign_in_at_user(user),
    do: Users.bump_user_last_sign_in_at!(user, DateTime.utc_now())

  def update(user, params) do
    attrs = SanitizeParams.call(params, @update_user_attrs)

    UpdateUser.call(user, attrs)
  end
end
