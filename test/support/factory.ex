defmodule Tails.Factory do
  @moduledoc false
  use ExMachina.Ecto, repo: Tails.Repo

  alias Tails.Users.User

  defp utc_in_seconds, do: DateTime.truncate(DateTime.utc_now(), :second)

  def user_factory(attrs \\ %{}) do
    current_pw = sequence(:password, &"Aa12345678912#{&1}")
    hash_pw = current_pw && Argon2.hash_pwd_salt(current_pw)

    user = %User{
      email: sequence(:email, &"email-#{&1}@tails.com"),
      password: current_pw,
      current_password: current_pw,
      password_hash: hash_pw,
      password_changed_at: utc_in_seconds(),
      status: :active
    }

    merge_attributes(user, attrs)
  end

  def initiated_user_factory() do
    current_pw = sequence(:password, &"Aa12345678912#{&1}")
    hash_pw = current_pw && Argon2.hash_pwd_salt(current_pw)

    %User{
      email: sequence(:email, &"email-#{&1}@tails.com"),
      password: current_pw,
      current_password: current_pw,
      password_hash: hash_pw,
      password_changed_at: utc_in_seconds(),
      status: :initiated
    }
  end
end
