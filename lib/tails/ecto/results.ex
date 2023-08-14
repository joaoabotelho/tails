defmodule Tails.Ecto.Results do
  @moduledoc """
  You can import the functions of this module explicitly or add them as delegates.
  """

  @type not_found :: {:error, :not_found | {:not_found, String.t()}}

  @doc """
  Normalize single results we typically get from contexts/finders that may either return
  one struct/map or nil.

  This is to avoid re-defining boilerplate code like:

    case Repo.get_by(Something, slug: "the-slug") do
      nil -> {:error, {:not_found, "The thing was not found"}}
      result -> {:ok, result}
    end
  """
  @spec normalize_one_result(any()) :: {:ok, any()} | {:error, :not_found}
  def normalize_one_result(nil), do: {:error, :not_found}
  def normalize_one_result(result), do: {:ok, result}

  @spec normalize_one_result(any(), String.t() | nil) ::
          {:ok, any()} | {:error, {:not_found, String.t()}}
  def normalize_one_result(result, nil), do: normalize_one_result(result)

  def normalize_one_result(nil, not_found_message)
      when is_binary(not_found_message) or is_atom(not_found_message),
      do: {:error, {:not_found, not_found_message}}

  def normalize_one_result(result, not_found_message)
      when is_binary(not_found_message) or is_atom(not_found_message),
      do: {:ok, result}
end
