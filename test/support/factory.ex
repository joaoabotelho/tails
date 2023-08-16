defmodule Tails.Factory do
  @moduledoc false
  use ExMachina.Ecto, repo: Tails.Repo

  alias Tails.Users.User
  alias Tails.Users.PersonalDetails
  alias Tails.Addresses.Address
  alias Tails.Pets.Pet

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
      status: :active,
      role: :client,
      profile_picture: "something"
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

  def address_factory(attrs \\ %{}) do
    address = %Address{
      address: sequence(:address, &"Street #{&1}"),
      address_line_2: sequence(:address, &"Address #{&1}"),
      postal_code: sequence(:address, &"Postal Code #{&1}"),
      city: sequence(:address, &"City #{&1}"),
      state: sequence(:address, &"State #{&1}")
    }

    merge_attributes(address, attrs)
  end

  def personal_details_factory(attrs \\ %{}) do
    {user, attrs} = Map.pop_lazy(attrs, :user, fn -> build(:user, role: :client) end)
    {address, attrs} = Map.pop_lazy(attrs, :user, fn -> build(:address) end)

    personal_details = %PersonalDetails{
      user: user,
      address: address,
      name: sequence(:name, &"John Doe #{&1}"),
      age: 10,
      mobile_number: "916915372",
      emergency_contact: "912589971",
      title: :miss
    }

    merge_attributes(personal_details, attrs)
  end

  def pet_factory(attrs \\ %{}) do
    {user, attrs} = Map.pop_lazy(attrs, :user, fn -> build(:user, role: :client) end)

    pet = %Pet{
      user: user,
      breed: sequence(:breed, &"Raca #{&1}"),
      name: sequence(:name, &"Paco #{&1}"),
      age: 10,
      castrated: true,
      trained: true,
      vaccination: true,
      sex: :male,
      vet_contact: "912912912",
      vet_name: "Maria",
      microship_id: "1234567890",
      type: :l_dog
    }

    merge_attributes(pet, attrs)
  end
end
