defmodule TailsWeb.API.V1.FriendshipView do
  use TailsWeb, :view

  alias Tails.Value.Response
  alias Tails.Users.Values.User
  alias Tails.Friendships.Values.Friendship

  def render("index.json", %{friends: friends}) do
    friends
    |> User.build()
    |> then(&Response.init(%{friends: &1}))
  end

  def render("index.json", %{blocked_users: blocked_users}) do
    blocked_users
    |> User.build()
    |> then(&Response.init(%{blocked_users: &1}))
  end

  def render("list_pending.json", %{friendships: friendships}) do
    friendships
    |> Friendship.build()
    |> then(&Response.init(%{friendships: &1}))
  end

  def render("success.json", _) do
    Response.init(%{status: :ok})
  end
end
