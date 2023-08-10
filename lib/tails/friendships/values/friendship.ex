defmodule Tails.Friendships.Values.Friendship do
  @moduledoc false

  alias Tails.Composite.Value
  alias Tails.Friendships.Friendship
  alias Tails.Users.Values.User

  def build(friendships) when is_list(friendships),
    do: Enum.map(friendships, &build/1)

  def build(%Friendship{} = friendship) do
    Value.init_with_map()
    |> Value.add(
      id: friendship.id,
      requester: User.build(friendship.requester),
      status: friendship.status
    )
  end
end
