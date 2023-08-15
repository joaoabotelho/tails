defmodule Tails.Files.Service.SanitizeFilename do
  @moduledoc """
  Sanitizes the filename depending on the file type.

  Fully replaces profile picture file name with `profile_picture` (+ extension).

  Limits max filename length to 120 due to AWS path + file type(contractor_invoice, personal_id, etc)
  """

  @name_max_length 120
  @default_profile_picture_name "profile_picture"

  @doc """
  Sanitizes the filename

  ## Parameters

    - name: String that represents the file name
    - type: Atom that represents the type of the file uploaded

  ## Examples

    iex> SanitizeFilename.call("sample_file.pdf", :id)
    "sample_file.pdf"

    iex> SanitizeFilename.call("john_doe.png", :profile_picture)
    "profile_picture.png"
  """
  @spec call(name :: String.t(), type :: atom()) :: String.t()
  def call(name, type)

  def call(name, :profile_picture), do: @default_profile_picture_name <> Path.extname(name)

  def call(name, _) do
    case String.length(name) > @name_max_length do
      true -> String.slice(name, -@name_max_length..-1)
      false -> name
    end
  end
end
