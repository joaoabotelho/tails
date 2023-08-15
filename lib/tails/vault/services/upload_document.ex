defmodule Tails.Vault.Service.UploadDocument do
  @moduledoc """
  Module responsible for uploading an unencrypted file to S3.

  The difference between this and Tails.Vault.Service.UploadEncryptedDocument is that this module does not encrypt
  files before uploading them to s3
  """

  @doc """
  Uploads a file to S3.
  """
  @spec call(String.t(), binary, String.t(), String.t()) ::
          {:ok, String.t()} | {:error, String.t()}
  def call(file_path, content, content_type, bucket) do
    case Application.get_env(:tails, :store_backend) do
      nil -> raise "Config :tails, :store_backend missing"
      backend -> backend.call(file_path, content, content_type, bucket)
    end
  end

  @spec call(String.t(), String.t(), keyword()) :: {:ok, String.t()} | {:error, any()}
  def call(path, content, opts) do
    storage_backend().upload(path, content, opts)
  end

  defp storage_backend do
    Application.fetch_env!(:tails, :file_storage_adapter)
  end
end
