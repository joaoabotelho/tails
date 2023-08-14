defmodule Tails.Users.Values.PersonalDetails do
  @moduledoc false

  alias Tails.Users.PersonalDetails
  alias Tails.Addresses.Values.Address

  def build(personal_details) when is_list(personal_details),
    do: Enum.map(personal_details, &build/1)

  def build(%PersonalDetails{} = personal_details) do
    %{
      name: personal_details.name,
      age: personal_details.age,
      mobile_number: personal_details.mobile_number,
      emergency_contact: personal_details.emergency_contact,
      title: personal_details.title,
      address: Address.build(personal_details.address)
    }
  end
end
