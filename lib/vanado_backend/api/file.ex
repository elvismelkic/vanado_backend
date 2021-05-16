defmodule VanadoBackend.Api.File do
  @moduledoc """
  The File API. Wrapper around Elixir's File module.
  """

  @root_path "./priv/static/"

  @doc """
  Creates folder along with its parents.
  """
  def create_folder_with_parents(path) do
    File.mkdir_p!("#{@root_path}#{path}")
  end

  @doc """
  Creates a file.
  """
  def create_file(source_file_path, destination_file_path) do
    File.cp!(source_file_path, "#{@root_path}#{destination_file_path}")
  end

  @doc """
  Deletes a file.
  """
  def delete(path) do
    File.rm!("#{@root_path}#{path}")
  end
end
