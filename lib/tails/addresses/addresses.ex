defmodule Tails.Addresses do
  @moduledoc """
  The Addresss context
  """
  alias Tails.Repo
  alias Tails.Addresses.Address

  @doc """
  Returns the list of addresss.

  ## Examples

      iex> list_addresss()
      [%Address{}, ...]

  """
  def list_addresss do
    Repo.all(Address)
  end

  def get_address(id), do: Repo.get(Address, id)

  def create_address(attrs \\ %{}) do
    %Address{}
    |> Address.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a Address.

  ## Examples

      iex> update_address(address, %{field: new_value})
      {:ok, %Address{}}

      iex> update_address(address, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_address(%Address{} = address, attrs) do
    address
    |> Address.changeset(attrs)
    |> Repo.update()
  end
end
