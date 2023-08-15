defmodule Tails.Vault.Storage do
  @moduledoc """
  Behaviour for modules that implement file storage support.
  """
  @callback upload(path :: String.t(), content :: String.t(), opts :: keyword()) ::
              {:ok, link :: String.t()} | {:error, reason :: any()}

  @callback download(link :: String.t()) ::
              {:ok, content :: String.t()} | {:error, reason :: any()}

  @callback(delete(link :: String.t()) :: :ok, {:error, reason :: any()})
end
