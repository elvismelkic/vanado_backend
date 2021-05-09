defmodule VanadoBackend.Machines do
  @moduledoc """
  The Machines context.
  """

  import Ecto.Query, warn: false
  alias VanadoBackend.Repo

  alias VanadoBackend.Machines.Machine

  @doc """
  Returns the list of machines.
  """
  def list_machines do
    Repo.all(Machine)
  end

  @doc """
  Gets a single machine with failures.

  Raises `Ecto.NoResultsError` if the Machine does not exist.
  """
  def get_machine!(id), do: Machine |> Repo.get!(id) |> Repo.preload(:failures)

  @doc """
  Creates a machine.
  """
  def create_machine(attrs \\ %{}) do
    %Machine{}
    |> Machine.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a machine.
  """
  def update_machine(%Machine{} = machine, attrs) do
    machine
    |> Machine.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a machine.
  """
  def delete_machine(%Machine{} = machine) do
    Repo.delete(machine)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking machine changes.
  """
  def change_machine(%Machine{} = machine, attrs \\ %{}) do
    Machine.changeset(machine, attrs)
  end
end
