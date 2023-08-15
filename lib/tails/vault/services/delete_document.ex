defmodule Tails.Vault.Service.DeleteDocument do
  @moduledoc """
  Deletes a document from storage.
  """

  @spec call(link :: String.t()) :: :ok | {:error, reason :: any()}
  def call(link) do
    storage_backend().delete(link)
  end

  defp storage_backend do
    Application.fetch_env!(:tails, :file_storage_adapter)
  end
end
