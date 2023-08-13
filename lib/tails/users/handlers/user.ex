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
end
