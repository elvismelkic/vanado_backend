defmodule VanadoBackendWeb.MachineControllerTest do
  use VanadoBackendWeb.ConnCase

  alias VanadoBackend.Machines.Machine

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all machines", %{conn: conn} do
      conn = get(conn, Routes.machine_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create machine" do
    test "renders machine when data is valid", %{conn: conn} do
      conn = post(conn, Routes.machine_path(conn, :create), machine: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.machine_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "name" => "some name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.machine_path(conn, :create), machine: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update machine" do
    setup [:create_machine]

    test "renders machine when data is valid", %{conn: conn, machine: %Machine{id: id} = machine} do
      conn = put(conn, Routes.machine_path(conn, :update, machine), machine: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.machine_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "name" => "some updated name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, machine: machine} do
      conn = put(conn, Routes.machine_path(conn, :update, machine), machine: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete machine" do
    setup [:create_machine]

    test "deletes chosen machine", %{conn: conn, machine: machine} do
      conn = delete(conn, Routes.machine_path(conn, :delete, machine))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.machine_path(conn, :show, machine))
      end
    end
  end

  defp create_machine(_) do
    machine = TestHelpers.create_machine()

    %{machine: machine}
  end
end
