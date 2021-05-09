defmodule VanadoBackendWeb.MachineController do
  use VanadoBackendWeb, :controller

  alias VanadoBackend.Machines
  alias VanadoBackend.Machines.Machine

  action_fallback VanadoBackendWeb.FallbackController

  def index(conn, _params) do
    machines = Machines.list()
    render(conn, "index.json", machines: machines)
  end

  def create(conn, %{"machine" => machine_params}) do
    with {:ok, %Machine{} = machine} <- Machines.create(machine_params) do
      machine = Machines.get_with_failures!(machine.id)

      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.machine_path(conn, :show, machine))
      |> render("show.json", machine: machine)
    end
  end

  def show(conn, %{"id" => id}) do
    machine = Machines.get_with_failures!(id)
    render(conn, "show.json", machine: machine)
  end

  def update(conn, %{"id" => id, "machine" => machine_params}) do
    %Machine{failures: failures} = machine = Machines.get_with_failures!(id)

    with {:ok, %Machine{} = machine} <- Machines.update(machine, machine_params) do
      machine = Map.put(machine, :failures, failures)
      render(conn, "show.json", machine: machine)
    end
  end

  def delete(conn, %{"id" => id}) do
    machine = Machines.get!(id)

    with {:ok, %Machine{}} <- Machines.delete(machine) do
      send_resp(conn, :no_content, "")
    end
  end
end
