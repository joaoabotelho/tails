defmodule Tails.Files.Service.ValidateFileExtension do
  @moduledoc """
  Validates the given file name matches one of the expected extensions.

  ## Examples

      iex> Tails.Files.Service.ValidateFileExtension.call("personal_id.png", [".png", ".pdf", ".jpeg"])
      :ok

      iex> Tails.Files.Service.ValidateFileExtension.call("personal_id.JPEG", [".png", ".pdf", ".jpeg"])
      :ok

      iex> Tails.Files.Service.ValidateFileExtension.call("tps_reports.xls", [".png", ".pdf", ".jpeg"])
      {:error, "Invalid file format"}
  """
  @spec call(name :: String.t(), extensions :: list(String.t())) ::
          :ok | {:error, reason :: String.t()}
  def call(name, extensions) do
    extension = Path.extname(name)

    case String.downcase(extension) in extensions do
      true -> :ok
      false -> {:error, "Invalid file format"}
    end
  end
end
