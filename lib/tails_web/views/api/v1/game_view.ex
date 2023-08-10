defmodule TailsWeb.API.V1.GameView do
  use TailsWeb, :view

  alias Tails.Value.Response
  alias Tails.Games.Values.Game

  def render("index.json", %{games: games}) do
    games
    |> Game.build()
    |> then(&Response.init(%{games: &1}))
  end
end
