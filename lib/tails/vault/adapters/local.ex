defmodule Tails.Vault.Adapters.Local do
  @moduledoc """
  Adapter implementation that stores files on `./media`, to be used during development.
  """
  @behaviour Tails.Vault.Storage

  @impl true
  # sobelow_skip ["Traversal"]
  def upload(path, content, _opts) do
    destination = Path.join(root_path(), path)
    File.mkdir_p!(Path.dirname(destination))

    File.write!(destination, content)

    uri = URI.merge(base_url(), path)
    {:ok, to_string(uri)}
  end

  @impl true
  # sobelow_skip ["Traversal"]
  def download(link) do
    %{path: path} = URI.parse(link)

    case File.read(Path.join(root_path(), path)) do
      {:ok, content} -> {:ok, content}
      {:error, reason} -> {:error, "Failed to read '#{path}': #{:file.format_error(reason)}"}
    end
  end

  @impl true
  # sobelow_skip ["Traversal"]
  def delete(link) do
    %{path: path} = URI.parse(link)

    case File.rm(Path.join(root_path(), path)) do
      :ok -> :ok
      {:error, reason} -> {:error, "Failed to delete '#{path}': #{:file.format_error(reason)}"}
    end
  end

  # sobelow_skip ["Traversal"]
  def clear! do
    File.rm_rf!(root_path())
  end

  defp root_path, do: Path.join([File.cwd!(), "media"])
  defp base_url, do: TailsWeb.Endpoint.url()
end
