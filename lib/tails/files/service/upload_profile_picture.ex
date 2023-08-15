defmodule Tails.Files.Service.UploadProfilePicture do
  @moduledoc """
  Uploads a profile picture, in case there is already one the old one is replaced.

  Unlike most uploads, this file isn't encrypted before being stored in a public bucket
  so it can be served directly from S3 instead of being proxied by the application
  """

  require Logger

  alias Tails.Users
  alias Tails.Files.Service.SanitizeMultipartUpload
  alias Tails.Repo
  alias Tails.Vault.Service.DeleteDocument
  alias Tails.Vault.Service.UploadDocument

  @doc """
  Uploads a profile picture
  """
  def call(user, %Plug.Upload{} = upload) do
    Repo.transaction(fn ->
      with {:ok, upload} <- SanitizeMultipartUpload.call(upload, :profile_picture),
           {:ok, link} <- replace_file(upload, user.profile_picture),
           {:ok, updated_user} <- update_user(user, link) do
        updated_user
      else
        {:error, reason} ->
          Repo.rollback(reason)
      end
    end)
  end

  defp replace_file(upload, nil) do
    opts = [public: true, content_type: build_content_type(upload.filepath)]
    UploadDocument.call(upload.filepath, upload.content, opts)
  end

  defp replace_file(upload, current) do
    with {:ok, link} <- replace_file(upload, nil),
         :ok <- DeleteDocument.call(current) do
      {:ok, link}
    end
  end

  defp build_content_type(filepath) do
    file_type = filepath |> Path.extname() |> String.replace(".", "")
    "image/#{file_type}"
  end

  defp update_user(user, link) do
    Users.update_user(user, %{profile_picture: link})
  end
end
