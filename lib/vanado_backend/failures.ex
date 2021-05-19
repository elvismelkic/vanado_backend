defmodule VanadoBackend.Failures do
  @moduledoc """
  The Failures context.
  """

  import Ecto.Query, warn: false

  alias VanadoBackend.Repo
  alias VanadoBackend.Failures.Failure
  alias VanadoBackend.Files

  @doc """
  Returns the list of failures conditionally filtered by `is_fixed` field.
  """
  def list(is_fixed \\ nil) do
    Failure
    |> maybe_filter(is_fixed)
    |> select([f], f)
    |> Repo.all()
    |> Repo.preload(:machine)
  end

  @doc """
  Gets a single failure.
  """
  def get!(id), do: Failure |> Repo.get!(id) |> Repo.preload([:machine, :files])

  @doc """
  Creates a failure for machine.
  """
  def create(attrs \\ %{}) do
    %Failure{}
    |> Failure.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a failure.
  """
  def update(%Failure{} = failure, attrs) do
    failure
    |> Failure.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a failure.
  """
  def delete(%Failure{} = failure) do
    Repo.transaction(fn repo ->
      failure
      |> Repo.delete()
      |> case do
        {:ok, failure} ->
          if length(failure.files) > 0, do: Files.delete_all_for_failure(failure.id)

          failure

        {:error, changeset} ->
          repo.rollback(changeset)
      end
    end)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking failure changes.
  """
  def change(%Failure{} = failure, attrs \\ %{}) do
    Failure.changeset(failure, attrs)
  end

  defp maybe_filter(failure, nil), do: failure
  defp maybe_filter(failure, is_fixed), do: failure |> where([f], f.is_fixed == ^is_fixed)
end
