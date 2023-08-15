defmodule Tails.Files.Service.ValidateBinaryContent do
  @moduledoc """
  Validates that the binary content matches the format we are expecting based on its extension

  From https://hexdocs.pm/elixir/Kernel.SpecialForms.html#%3C%3C%3E%3E/1-binary-bitstring-matching
  """

  # File format magic bytes

  # https://www.etsi.org/deliver/etsi_en/319100_319199/31916201/01.01.01_60/en_31916201v010101p.pdf
  @asic_signature <<80::size(8), 75::size(8), 3::size(8), 4::size(8)>>

  @exception_extensions [
    ".asice",
    ".sce",
    ".asics",
    ".scs",
    ".csv",
    ".txt"
  ]

  @spec call(content :: String.t(), filename :: String.t()) ::
          :ok | {:error, reason :: String.t()}
  def call(content, filename) do
    case valid_mime_content?(filename, content) do
      true -> :ok
      false -> {:error, "Invalid file contents"}
    end
  end

  defp valid_mime_content?(filename, content) do
    extension =
      filename
      |> Path.extname()
      |> String.downcase()

    if Enum.member?(@exception_extensions, extension) do
      content_matches?(extension, content)
    else
      mime_from_path = MIME.from_path(filename)

      {:string, content}
      |> ExMarcel.MimeType.for()
      |> Kernel.==(mime_from_path)
    end
  end

  defp content_matches?(".asice", <<@asic_signature, _rest::binary>>), do: true
  defp content_matches?(".sce", <<@asic_signature, _rest::binary>>), do: true
  defp content_matches?(".asics", <<@asic_signature, _rest::binary>>), do: true
  defp content_matches?(".scs", <<@asic_signature, _rest::binary>>), do: true
  defp content_matches?(".csv", _cant_really_verify), do: true
  defp content_matches?(".txt", _cant_really_verify), do: true
  defp content_matches?(_, _), do: false
end
