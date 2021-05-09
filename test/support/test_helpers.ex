defmodule VanadoBackend.TestHelpers do
  @moduledoc """
  Test Helpers for creating database records
  """

  alias VanadoBackend.Failures
  alias VanadoBackend.Machines

  @machine_attrs %{name: "test machine"}
  @failure_attrs %{name: "test failure", description: nil, is_fixed: false, priority: :moderate}

  def create_machine do
    {:ok, machine} = Machines.create_machine(@machine_attrs)

    machine
  end

  def create_machine_with_failure do
    machine = create_machine()

    {:ok, failure} =
      @failure_attrs
      |> Map.merge(%{machine_id: machine.id})
      |> Failures.create_failure()

    machine |> Map.put(:failures, [failure])
  end
end
