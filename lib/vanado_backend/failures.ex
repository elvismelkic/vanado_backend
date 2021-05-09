defmodule VanadoBackend.Failures do
  @moduledoc """
  The Failures context.
  """

  import Ecto.Query, warn: false
  alias VanadoBackend.Repo

  alias VanadoBackend.Failures.Failure

  @doc """
  Returns the list of failures conditionally filtered by `is_fixed` field.
  """
  def list(is_fixed \\ nil) do
    Failure
    |> maybe_filter(is_fixed)
    |> select([f], f)
    |> Repo.all()
  end

  @doc """
  Gets a single failure.
  """
  def get!(id), do: Repo.get!(Failure, id)

  @doc """
  Creates a failure for machine.
  """
  def create(machine, attrs \\ %{}) do
    machine
    |> Ecto.build_assoc(:failures)
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
    Repo.delete(failure)
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
