defmodule Tails.Vault.Adapters.Stub do
  @moduledoc false
  @behaviour Tails.Vault.Storage

  @impl true
  def upload(path, _content, _opts) do
    uri = URI.merge("http://test.host/", path)
    {:ok, to_string(uri)}
  end

  @impl true
  def download(_link) do
    {:ok, "467B67CE5A62DA5CE29E17B1B9F0F33E"}
  end

  @impl true
  def delete(_link), do: :ok
end
