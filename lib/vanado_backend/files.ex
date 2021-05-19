defmodule VanadoBackend.Files do
  @moduledoc """
  The Files context.
  """

  import Ecto.Query, warn: false
  alias VanadoBackend.Repo
  alias VanadoBackend.Api.File

  alias VanadoBackend.Files.File, as: VanadoFile

  @file_module Application.get_env(:vanado_backend, :file, File)

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
    Repo.transaction(fn repo ->
      %VanadoFile{}
      |> VanadoFile.changeset(attrs)
      |> repo.insert()
      |> case do
        {:ok, file} ->
          @file_module.create_folder_with_parents!("failure_#{file.failure_id}/")
          @file_module.create_file!(attrs.path, "failure_#{file.failure_id}/#{file.name}")
          list_for_failure(attrs.failure_id)

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
          @file_module.delete_file!("failure_#{failure_id}/#{name}")
          list_for_failure(failure_id)

        {:error, changeset} ->
          repo.rollback(changeset)
      end
    end)
  end

  @doc """
  Deletes all failure's files.
  """
  def delete_all_for_failure(failure_id) do
    Repo.transaction(fn repo ->
      VanadoFile
      |> where([f], f.failure_id == ^failure_id)
      |> select([f], f)
      |> repo.delete_all()
      |> case do
        {_number_of_deleted_items, _deleted_items} ->
          @file_module.delete_folder!("failure_#{failure_id}/")

        _error ->
          repo.rollback("something went wrong")
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
