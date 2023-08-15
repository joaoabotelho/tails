defmodule Tails.Files.Service.SanitizeMultipartUpload do
  @moduledoc """
  Module to sanitize and convert `Plug.Upload` structs into a structure ready
  for our own use if the upload is one of the know kinds of uploads we support.

  Please check `Tails.Files.UploadConfig` for list for the constraints for each kind of upload,
  and the following modules to how they are validated:

  * `Tails.Files.Service.SanitizeFilePath` for validating that the upload is located where we expect it to be.
  * `Tails.Files.Service.ValidateBinaryContent` for validating that the upload's content is the binary that we expect.
  * `Tails.Files.Service.ValidateFileExtension` to check if the file name has the expected extensions.
  * `Tails.Files.Service.ValidateFileMaxSize` for validating the upload file size.
  """

  alias Tails.Files.Service.FilePath
  alias Tails.Files.Service.SanitizeExif
  alias Tails.Files.Service.SanitizeFilename
  alias Tails.Files.Service.SanitizeFilePath
  alias Tails.Files.Service.ValidateBinaryContent
  alias Tails.Files.Service.ValidateFileExtension
  alias Tails.Files.Service.ValidateFileMaxSize

  alias Tails.Files.UploadConfig

  @type sanitized_upload :: %{
          required(:content) => binary(),
          required(:filepath) => binary(),
          required(:name) => binary(),
          required(:slug) => binary()
        }

  @type multi_part_upload :: %{
          path: binary(),
          filename: binary(),
          content_type: binary() | nil
        }

  # sobelow_skip ["Traversal"]
  @spec call(upload :: Plug.Upload.t() | multi_part_upload(), type :: atom()) ::
          {:ok, sanitized_upload :: sanitized_upload()} | {:error, reason :: any()}
  def call(%{path: filepath, filename: filename} = _upload, type) do
    slug = Ecto.UUID.generate()
    %{extensions: extensions, max_size: max_size} = UploadConfig.fetch!(type)

    name = SanitizeFilename.call(filename, type)

    with {:ok, path} <- SanitizeFilePath.call(filepath),
         :ok <- ValidateFileExtension.call(name, extensions),
         :ok <- ValidateFileMaxSize.call(path, max_size),
         {:ok, content} <- File.read(path),
         :ok <- ValidateBinaryContent.call(content, name),
         {:ok, sanitized_content} <- SanitizeExif.call(content, type) do
      filepath = FilePath.call(type, slug, name)

      {:ok,
       %{
         content: sanitized_content,
         filepath: filepath,
         name: name,
         slug: slug
       }}
    end
  end
end
