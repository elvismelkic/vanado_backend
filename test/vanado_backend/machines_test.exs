defmodule VanadoBackend.MachinesTest do
  use VanadoBackend.DataCase

  alias VanadoBackend.Machines

  describe "machines" do
    alias VanadoBackend.Machines.Machine

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    test "list/0 returns all machines" do
      machine = TestHelpers.create_machine()

      assert Machines.list() == [machine]
    end

    test "get!/1 returns the machine with given id" do
      machine = TestHelpers.create_machine()

      assert Machines.get!(machine.id) == machine
    end

    test "get_with_failures!/1 returns the machine and its failures with given id" do
      machine = TestHelpers.create_machine_with_failure()

      assert Machines.get_with_failures!(machine.id) == machine
    end

    test "create/1 with valid data creates a machine" do
      assert {:ok, %Machine{} = machine} = Machines.create(@valid_attrs)
      assert machine.name == "some name"
    end

    test "create/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Machines.create(@invalid_attrs)
    end

    test "update/2 with valid data updates the machine" do
      machine = TestHelpers.create_machine()

      assert {:ok, %Machine{} = machine} = Machines.update(machine, @update_attrs)
      assert machine.name == "some updated name"
    end

    test "update/2 with invalid data returns error changeset" do
      machine = TestHelpers.create_machine()

      assert {:error, %Ecto.Changeset{}} = Machines.update(machine, @invalid_attrs)
      assert machine == Machines.get!(machine.id)
    end

    test "delete/1 deletes the machine" do
      machine = TestHelpers.create_machine()

      assert {:ok, %Machine{}} = Machines.delete(machine)
      assert_raise Ecto.NoResultsError, fn -> Machines.get!(machine.id) end
    end

    test "change/1 returns a machine changeset" do
      machine = TestHelpers.create_machine()

      assert %Ecto.Changeset{} = Machines.change(machine)
    end
  end
end
