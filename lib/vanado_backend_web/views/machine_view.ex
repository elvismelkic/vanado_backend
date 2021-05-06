defmodule VanadoBackendWeb.MachineView do
  use VanadoBackendWeb, :view
  alias VanadoBackendWeb.MachineView
  alias VanadoBackendWeb.FailureView

  def render("index.json", %{machines: machines}) do
    %{data: render_many(machines, MachineView, "machine.json")}
  end

  def render("show.json", %{machine: machine}) do
    %{data: render_one(machine, MachineView, "machine_with_failures.json")}
  end

  def render("machine.json", %{machine: machine}) do
    %{id: machine.id, name: machine.name}
  end

  def render("machine_with_failures.json", %{machine: machine}) do
    %{
      id: machine.id,
      name: machine.name,
      failures: render_many(machine.failures, FailureView, "failure.json")
    }
  end
end
