defmodule Tails.Addresses.Values.Address do
  @moduledoc false

  alias Tails.Addresses.Address

  def build(address) when is_list(address),
    do: Enum.map(address, &build/1)

  def build(%Address{} = address) do
    %{
      address: address.address,
      address_line_2: address.address_line_2,
      city: address.city,
      postal_code: address.postal_code,
      state: address.state
    }
  end
end
