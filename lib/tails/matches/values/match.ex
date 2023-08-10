defmodule Tails.Matches.Values.Match do
  @moduledoc false

  alias Tails.Composite.Value
  alias Tails.Matches.Match
  alias Tails.Matches.Values.Player
  alias Tails.Games.Values.Game

  def build(users) when is_list(users),
    do: Enum.map(users, &build/1)

  def build(%Match{} = match) do
    Value.init_with_map()
    |> Value.add(
      id: match.id,
      inserted_at: match.inserted_at,
      players: Player.build(match.players),
      game: Game.build(match.game)
    )
  end
end
