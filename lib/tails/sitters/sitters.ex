defmodule Tails.Sitters.Sitters do
  @moduledoc """
  The Sitters context
  """
  alias Tails.Repo
  alias Tails.Sitters.Sitter

  @doc """
  Returns the list of sitters.

  ## Examples

      iex> list_sitters()
      [%Sitter{}, ...]

  """
  def list_sitters do
    Repo.all(Sitter)
  end

  def get_sitter(id), do: Repo.get(Sitter, id)

  def create_sitter(attrs \\ %{}) do
    %Sitter{}
    |> Sitter.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a Sitter.

  ## Examples

      iex> update_sitter(sitter, %{field: new_value})
      {:ok, %Sitter{}}

      iex> update_sitter(sitter, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_sitter(%Sitter{} = sitter, attrs) do
    sitter
    |> Sitter.changeset(attrs)
    |> Repo.update()
  end
end
