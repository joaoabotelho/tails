defmodule Tails.Users.Values.User do
  @moduledoc false

  alias Tails.Composite.Value
  alias Tails.Users.User

  def build(users) when is_list(users),
    do: Enum.map(users, &build/1)

  def build(%User{} = user) do
    Value.init_with_map()
    |> Value.add(
      status: user.status,
      role: user.role,
      slug: user.slug,
      email: user.email
    )
  end
end
