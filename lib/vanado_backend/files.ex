defmodule VanadoBackend.Files do
  @moduledoc """
  The Files context.
  """

  import Ecto.Query, warn: false
  alias VanadoBackend.Repo

  alias VanadoBackend.Files.File, as: VanadoFile

  @doc """
  Returns the list of failure's files.
  """
  def list_for_failure(failure_id) do
    VanadoFile
    |> where([f], f.failure_id == ^failure_id)
    |> select([f], f)
    |> Repo.all()
  end

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

    Repo.transaction(fn repo ->
      %VanadoFile{}
      |> VanadoFile.changeset(files)
      |> repo.insert()
      |> case do
        {:ok, file} ->
          File.mkdir_p!("./priv/static/failure_#{file.failure_id}/")
          File.cp!(files.path, "./priv/static/failure_#{file.failure_id}/#{file.name}")
          list_for_failure(failure_id)

        {:error, changeset} ->
          repo.rollback(changeset)
      end
    end)
  end

  @doc """
  Deletes a file.
  """
  def delete(id) do
    %VanadoFile{name: name, failure_id: failure_id} = file = get!(id)

    Repo.transaction(fn repo ->
      file
      |> repo.delete()
      |> case do
        {:ok, _file} ->
          File.rm!("./priv/static/failure_#{failure_id}/#{name}")
          list_for_failure(failure_id)

        {:error, changeset} ->
          repo.rollback(changeset)
      end
    end)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking file changes.
  """
  def change(%VanadoFile{} = file, attrs \\ %{}) do
    VanadoFile.changeset(file, attrs)
  end

  defp get!(id), do: VanadoFile |> Repo.get!(id)
end
