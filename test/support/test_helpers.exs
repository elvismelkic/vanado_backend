defmodule VanadoBackend.TestHelpers do
  @moduledoc """
  Test Helpers for creating database records
  """

  alias VanadoBackend.Failures
  alias VanadoBackend.Machines
  alias VanadoBackend.Repo

  @machine_attrs %{name: "test machine"}
  @failure_attrs %{name: "test failure", description: nil, is_fixed: false, priority: :medium}

  def create_machine do
    Machines.create_machine(@machine_attrs)
  end

  def create_machine_with_failure do
    {:ok, machine} = create_machine()

    @failure_attrs
    |> Map.merge(%{machine_id: machine.id})
    |> Failures.create_failure()
  end
end
