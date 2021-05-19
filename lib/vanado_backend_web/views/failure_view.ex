defmodule VanadoBackendWeb.FailureView do
  use VanadoBackendWeb, :view
  alias VanadoBackendWeb.FailureView
  alias VanadoBackendWeb.FileView
  alias VanadoBackendWeb.MachineView

  def render("index.json", %{failures: failures}) do
    %{data: render_many(failures, FailureView, "failure_with_machine.json")}
  end

  def render("show.json", %{failure: failure}) do
    %{data: render_one(failure, FailureView, "failure.json")}
  end

  def render("show_full.json", %{failure: failure}) do
    %{data: render_one(failure, FailureView, "full_failure.json")}
  end

  def render("failure.json", %{failure: failure}), do: failure_basic_fields(failure)

  def render("full_failure.json", %{failure: failure}) do
    failure
    |> failure_basic_fields()
    |> Map.put(:machine, render_one(failure.machine, MachineView, "machine.json"))
    |> Map.put(:files, render_many(failure.files, FileView, "file.json"))
  end

  def render("failure_with_machine.json", %{failure: failure}) do
    failure
    |> failure_basic_fields()
    |> Map.put(:machine, render_one(failure.machine, MachineView, "machine.json"))
  end

  defp failure_basic_fields(failure) do
    %{
      id: failure.id,
      name: failure.name,
      description: failure.description,
      is_fixed: failure.is_fixed,
      priority: failure.priority,
      machine_id: failure.machine_id
    }
  end
end
