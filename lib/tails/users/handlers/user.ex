defmodule Tails.Users.Handler.User do
  @moduledoc """
  Handler for User
  """

  alias Tails.Service.SanitizeParams
  alias Tails.Users.Users

  def complete_profile(%{status: :initiated} = user, params) do
    attrs = SanitizeParams.call(params, ["name"])

    Users.update_user(user, Map.merge(attrs, %{status: :active}))
  end

  def complete_profile(_, _), do: {:error, 422, "user already active"}

  def get_personal_details_for_user(user),
    do: Users.fetch_user(user.id, personal_details: [:address])

  def update_last_sign_in_at_user(user),
    do: Users.bump_user_last_sign_in_at!(user, DateTime.utc_now())
end
