defmodule VanadoBackend.TestHelpers do
  @moduledoc """
  Test Helpers for creating database records
  """

  alias VanadoBackend.Failures
  alias VanadoBackend.Machines
  alias VanadoBackend.Repo

  @machine_attrs %{name: "test machine"}
  @failure_attrs %{name: "test failure", description: nil, is_fixed: false, priority: :moderate}

  def create_machine do
    {:ok, machine} = Machines.create(@machine_attrs)

    machine
  end

  def create_machine_with_failure do
    machine = create_machine()

    {:ok, failure} =
      @failure_attrs
      |> Map.put(:machine_id, machine.id)
      |> Failures.create()

    machine |> Map.put(:failures, [failure])
  end

  def create_failure do
    machine = create_machine_with_failure()

    hd(machine.failures)
  end

  def create_failure_with_machine do
    machine = create_machine_with_failure()

    machine.failures |> hd() |> Repo.preload(:machine)
  end
end
