defmodule VanadoBackend.Files do
  @moduledoc """
  The Files context.
  """

  import Ecto.Query, warn: false
  alias VanadoBackend.Repo

  alias VanadoBackend.Files.File, as: VanadoFile

  @doc """
  Gets a single file.

  Raises `Ecto.NoResultsError` if the File does not exist.
  """
  def get!(id), do: VanadoFile |> Repo.get!(id)

  @doc """
  Creates a file.
  """
  def create(attrs \\ %{}) do
    failure_id = attrs["failure"]
    attr_files = attrs["files"]

    files = %{
      failure_id: failure_id,
      name: attr_files.filename,
      type: attr_files.content_type,
      path: attr_files.path
    }

    %VanadoFile{}
    |> VanadoFile.changeset(files)
    |> Repo.insert()
    |> case do
      {:ok, file} ->
        File.mkdir_p("./priv/static/failure_#{file.failure_id}/")
        File.cp(files.path, "./priv/static/failure_#{file.failure_id}/#{file.name}")

        {:ok, file}

      error ->
        error
    end
  end

  @doc """
  Deletes a file.
  """
  def delete(%VanadoFile{} = file) do
    Repo.delete(file)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking file changes.
  """
  def change(%VanadoFile{} = file, attrs \\ %{}) do
    VanadoFile.changeset(file, attrs)
  end
end
