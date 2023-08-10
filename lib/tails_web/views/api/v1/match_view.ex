defmodule TailsWeb.API.V1.MatchView do
  use TailsWeb, :view

  alias Tails.Value.Response
  alias Tails.Matches.Values.Match

  def render("index.json", %{matches: matches}) do
    matches
    |> Match.build()
    |> then(&Response.init(%{matches: &1}))
  end

  def render("success.json", _) do
    Response.init(%{status: :ok})
  end
end
