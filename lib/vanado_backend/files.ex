defmodule VanadoBackend.Files do
  @moduledoc """
  The Files context.
  """

  import Ecto.Query, warn: false
  alias VanadoBackend.Repo

  alias VanadoBackend.Files.File

  @doc """
  Gets a single file.

  Raises `Ecto.NoResultsError` if the File does not exist.
  """
  def get!(id), do: File |> Repo.get!(id)

  @doc """
  Creates a file.
  """
  def create(attrs \\ %{}) do
    %File{}
    |> File.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Deletes a file.
  """
  def delete(%File{} = file) do
    Repo.delete(file)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking file changes.
  """
  def change(%File{} = file, attrs \\ %{}) do
    File.changeset(file, attrs)
  end
end
