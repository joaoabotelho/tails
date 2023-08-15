defmodule Tails.Files.Service.FilePath do
  @moduledoc """
  Builds the file path for each file type
  """

  def call(:profile_picture, uuid, name), do: "profile_pictures/#{uuid}#{name}"
end
