defmodule Tails.Files.UploadConfig do
  @moduledoc """
  Holds the constraints for file uploads regarding allowed extensions and file size limits
  """

  defmodule FileConfig do
    @moduledoc """
    Helper module to calculate file configs and extensions at compile time.
    """
    def add_default_max_size_to_file_types(file_types, default_max_size) do
      Map.new(file_types, fn {type, opts} ->
        {type, Map.put_new(opts, :max_size, default_max_size)}
      end)
    end

    def get_all_extensions(config) do
      Map.keys(config)
      |> Enum.flat_map(fn file_type -> config[file_type][:extensions] end)
      |> Enum.uniq()
    end
  end

  @type t :: %{
          required(:extensions) => list(),
          required(:max_size) => non_neg_integer()
        }

  @megabyte 1024 * 1024
  @default_max_size 20 * @megabyte

  @file_types %{
    profile_picture: %{extensions: [".png", ".jpg", ".jpeg"], max_size: 2 * @megabyte}
  }

  @config FileConfig.add_default_max_size_to_file_types(@file_types, @default_max_size)
  @extensions FileConfig.get_all_extensions(@config)

  @spec get_all() :: %{optional(atom) => t()}
  def get_all, do: @config

  @spec get_all_extensions() :: list(String.t())
  def get_all_extensions, do: @extensions

  @spec fetch!(atom()) :: t()
  def fetch!(key), do: Map.fetch!(@config, key)
end
