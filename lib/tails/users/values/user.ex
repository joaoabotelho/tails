defmodule Tails.Users.Values.User do
  @moduledoc false

  alias Tails.Users.User
  alias Tails.Users.Values.PersonalDetails

  def build(users) when is_list(users),
    do: Enum.map(users, &build/1)

  def build(%User{} = user) do
    %{
      slug: user.slug,
      role: user.role,
      status: user.status,
      email: user.email,
      personal_details: PersonalDetails.build(user.personal_details)
    }
  end
end
