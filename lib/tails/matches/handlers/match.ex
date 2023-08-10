defmodule Tails.Matches.Handler.Match do
  @moduledoc """
  Handler for Matches
  """

  alias Tails.Matches.Services.SanitizeMatchParams
  alias Tails.Matches

  def create(_user, params) do
    {:ok, attrs} = SanitizeMatchParams.call(params)

    Matches.create_match(attrs)
  end

  def get_user_matches(user), do: Matches.list_user_recent_games(user.id)
end
