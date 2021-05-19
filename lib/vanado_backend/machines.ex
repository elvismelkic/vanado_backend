defmodule VanadoBackend.Machines do
  @moduledoc """
  The Machines context.
  """

  import Ecto.Query, warn: false

  alias VanadoBackend.Files
  alias VanadoBackend.Repo
  alias VanadoBackend.Machines.Machine

  @doc """
  Returns the list of machines.
  """
  def list do
    Repo.all(Machine)
  end

  @doc """
  Gets a single machine.

  Raises `Ecto.NoResultsError` if the Machine does not exist.
  """
  def get!(id), do: Machine |> Repo.get!(id)

  @doc """
  Gets a single machine with its failures.

  Raises `Ecto.NoResultsError` if the Machine does not exist.
  """
  def get_with_failures!(id), do: Machine |> Repo.get!(id) |> Repo.preload(:failures)

  @doc """
  Creates a machine.
  """
  def create(attrs \\ %{}) do
    %Machine{}
    |> Machine.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a machine.
  """
  def update(%Machine{} = machine, attrs) do
    machine
    |> Machine.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a machine.
  """
  def delete(%Machine{} = machine) do
    Repo.transaction(fn repo ->
      machine_failures = machine |> Repo.preload(failures: :files) |> (& &1.failures).()
      files = machine_failures |> Enum.flat_map(& &1.files)

      machine
      |> Repo.delete()
      |> case do
        {:ok, machine} ->
          if length(files) > 0,
            do: Enum.each(machine_failures, &Files.delete_all_for_failure(&1.id))

          machine

        {:error, changeset} ->
          repo.rollback(changeset)
      end
    end)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking machine changes.
  """
  def change(%Machine{} = machine, attrs \\ %{}) do
    Machine.changeset(machine, attrs)
  end
end
