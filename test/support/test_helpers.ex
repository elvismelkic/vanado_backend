defmodule VanadoBackend.TestHelpers do
  @moduledoc """
  Test Helpers for creating database records
  """

  alias VanadoBackend.Failures
  alias VanadoBackend.Files.File
  alias VanadoBackend.Machines
  alias VanadoBackend.Repo

  @machine_attrs %{name: "test machine"}
  @failure_attrs %{name: "test failure", description: nil, is_fixed: false, priority: :moderate}
  @file_attrs %{name: "test file", type: "image/jpg"}

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

  def create_file do
    failure = create_failure()

    file =
      %File{}
      |> File.changeset(Map.put(@file_attrs, :failure_id, failure.id))
      |> Repo.insert!()

    file
  end

  def file_upload_struct(attrs) do
    %Plug.Upload{
      content_type: attrs.type,
      filename: attrs.name,
      path: "temp/file/path"
    }
  end
end
