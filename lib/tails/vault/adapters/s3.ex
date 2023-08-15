defmodule Tails.Vault.Adapters.S3 do
  @moduledoc """
  Adapter implementation that stores files on S3 buckets
  """
  @behaviour Tails.Vault.Storage

  require Logger

  @impl true
  @doc """
  Uploads a file to S3.

  WARNING: If a file exists at the provided `path`, it will be overwritten!

  Context: https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/s3.html#S3.Client.put_object
  """
  def upload(path, content, opts) do
    {bucket, s3_opts} = upload_options(opts)

    case do_upload(bucket, path, content, s3_opts) do
      {:ok, _} ->
        uri = URI.merge("https://#{bucket}.s3.amazonaws.com/", path)
        {:ok, to_string(uri)}

      {:error, reason} ->
        send_error(:upload, path, reason)
        {:error, "Error uploading"}
    end
  end

  @impl true
  def download(link) do
    path = get_file_path(link)

    case do_download(get_bucket(link), path) do
      {:ok, %{body: content}} ->
        {:ok, content}

      {:error, {:http_error, 404, _}} ->
        send_error(:download, path, :not_found)
        {:error, "Error downloading"}

      {:error, reason} ->
        send_error(:download, path, reason)
        {:error, "Error downloading"}
    end
  end

  @impl true
  def delete(link) do
    path = get_file_path(link)

    case do_delete(get_bucket(link), path) do
      {:ok, _} ->
        :ok

      {:error, {:http_error, 404, _}} ->
        send_error(:delete, path, :not_found)
        {:error, "Error deleting"}

      {:error, reason} ->
        send_error(:delete, path, reason)
        {:error, "Error deleting"}
    end
  end

  defp do_upload(bucket, path, content, opts) do
    bucket
    |> ExAws.S3.put_object(path, content, opts)
    |> ExAws.request()
  end

  defp do_download(bucket, path) do
    bucket
    |> ExAws.S3.get_object(path)
    |> ExAws.request()
  end

  defp do_delete(bucket, path) do
    bucket
    |> ExAws.S3.delete_object(path)
    |> ExAws.request()
  end

  defp get_file_path(link) do
    link
    |> String.replace(~r/https:\/\/.*\.s3\.amazonaws\.com/, "")
    |> String.replace(public_link_prefix(), "")
  end

  defp get_bucket(link) do
    case String.starts_with?(link, public_link_prefix()) do
      true -> fetch_env!(:s3_public_bucket)
      _ -> fetch_env!(:s3_vault_bucket)
    end
  end

  defp public_link_prefix, do: TailsWeb.Endpoint.url()

  defp upload_options(opts) do
    case Keyword.get(opts, :public) do
      true ->
        {
          fetch_env!(:s3_public_bucket),
          [{:content_type, Keyword.fetch!(opts, :content_type)}]
        }

      _ ->
        {
          fetch_env!(:s3_vault_bucket),
          [{:encryption, [aws_kms_key_id: fetch_env!(:kms_key_alias)]}]
        }
    end
  end

  defp fetch_env!(key), do: Application.fetch_env!(:tails, key)

  defp send_error(action, path, reason) do
    Logger.error("[S3] failed to #{action} - path: #{path}, reason: #{inspect(reason)}")
    # Errors.send_error(%AdapterError{action: action, path: path, message: inspect(reason)})
  end
end
