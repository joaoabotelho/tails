defmodule Tails.Files.Service.SanitizeFilePath do
  @moduledoc """
  Validates a file path
  """
  def call(path) do
    case String.starts_with?(path, [to_string(:code.priv_dir(:tails)), "/var/", "/tmp/"]) do
      true ->
        {:ok, sanitize_path(path)}

      _ ->
        {:error, "Invalid path"}
    end
  end

  defp sanitize_path(path) do
    path
    |> String.replace("../", "")
    |> String.replace("~/", "")
  end
end
