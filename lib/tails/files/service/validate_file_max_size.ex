defmodule Tails.Files.Service.ValidateFileMaxSize do
  @moduledoc """
  Validates binary files max size
  """

  @megabyte 1024 * 1024

  def call(path, max_size) do
    with {:ok, %{size: file_size}} <- File.stat(path) do
      validate_size(file_size, max_size)
    end
  end

  defp validate_size(file_size, max_size) do
    case file_size <= max_size do
      true ->
        :ok

      false ->
        {:error, "File must be smaller than #{round(max_size / @megabyte)}MB"}
    end
  end
end
