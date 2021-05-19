defmodule VanadoBackend.TestHelpers do
  @moduledoc """
  Test Helpers for creating database records
  """

  alias VanadoBackend.Failures
  alias VanadoBackend.Files
  alias VanadoBackend.Files.File
  alias VanadoBackend.Machines
  alias VanadoBackend.Repo

  @machine_attrs %{name: "test machine"}
  @failure_attrs %{name: "test failure", description: nil, is_fixed: false, priority: :moderate}
  @file_attrs %{name: "test file", type: "image/jpg", path: "some/test/path"}

  def create_machine do
    {:ok, machine} = Machines.create(@machine_attrs)

    machine
  end

  def create_machine_with_failure do
    machine = create_machine()

    {:ok, _failure} =
      @failure_attrs
      |> Map.put(:machine_id, machine.id)
      |> Failures.create()

    machine |> Repo.preload(:failures)
  end

  def create_failure do
    machine = create_machine_with_failure()

    machine.failures |> hd() |> Repo.preload([:machine, :files])
  end

  def create_failure_with_machine do
    machine = create_machine_with_failure()

    machine.failures |> hd() |> Repo.preload(:machine)
  end

  def create_failure_with_file do
    failure = create_failure()

    {:ok, _files} =
      @file_attrs
      |> Map.put(:failure_id, failure.id)
      |> Files.create()

    failure |> Repo.preload(:files)
  end

  def create_file do
    failure = create_failure()

    {:ok, files} =
      @file_attrs
      |> Map.put(:failure_id, failure.id)
      |> Files.create()

    hd(files)
  end
end
