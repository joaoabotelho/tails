defmodule Tails.Files.Service.SanitizeExif do
  @moduledoc """
  Sanitizes the EXIF on the file by completely removing all the data related to APP0(0xFFE0) and APP1(0xFFE1),
  in other words, JFIF and EXIF/TIFF respectively.

  The information being removed is information such as GEO location, Device that took the picture, etc...

  Info on how JFIF, EXIF and TIFF works: https://www.media.mit.edu/pia/Research/deepview/exif.html
  """

  @soi_marker <<0xFF, 0xD8>>
  @jfif_marker <<0xFF, 0xE0>>
  @exif_marker <<0xFF, 0xE1>>

  @spec call(content :: String.t(), type :: atom()) :: {:ok, String.t()}
  def call(content, type)

  def call(content, :profile_picture), do: {:ok, strip_exif_data(content)}

  def call(content, _), do: {:ok, content}

  defp strip_exif_data(<<@soi_marker, @exif_marker, size::16, rest::binary>>) do
    data_size = size - 2
    <<_::binary-size(data_size), img::binary>> = rest
    strip_exif_data(<<@soi_marker, img::binary>>)
  end

  defp strip_exif_data(<<@soi_marker, @jfif_marker, size::16, rest::binary>>) do
    data_size = size - 2
    <<_::binary-size(data_size), img::binary>> = rest
    strip_exif_data(<<@soi_marker, img::binary>>)
  end

  defp strip_exif_data(content), do: content
end
