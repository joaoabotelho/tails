defmodule TailsWeb.API.V1.UserView do
  use TailsWeb, :view

  alias Tails.Value.Response
  alias Tails.Users.Values.User

  def render("show.json", %{user: user}) do
    user
    |> User.build()
  end

  def render("success.json", _) do
    Response.init(%{status: :ok})
  end
end
