defmodule VanadoBackend.FailuresTest do
  use VanadoBackend.DataCase

  alias VanadoBackend.Failures

  describe "failures" do
    alias VanadoBackend.Failures.Failure

    @valid_attrs %{description: nil, is_fixed: true, name: "some name", priority: :moderate}
    @update_attrs %{description: nil, is_fixed: false, name: "some updated name", priority: :high}
    @invalid_attrs %{description: nil, is_fixed: nil, name: nil, priority: nil, machine_id: nil}

    test "list/0 returns all failures" do
      failure = TestHelpers.create_failure()

      assert Failures.list() == [failure]
    end

    test "get!/1 returns the failure with given id" do
      failure = TestHelpers.create_failure()

      assert Failures.get!(failure.id) == failure
    end

    test "create/1 with valid data creates a failure" do
      machine = TestHelpers.create_machine()

      assert {:ok, %Failure{} = failure} = Failures.create(machine, @valid_attrs)
      assert failure.description == nil
      assert failure.is_fixed == true
      assert failure.name == "some name"
      assert failure.priority == :moderate
      assert failure.machine_id == machine.id
    end

    test "create/1 with invalid data returns error changeset" do
      machine = TestHelpers.create_machine()

      assert {:error, changeset} = Failures.create(machine, @invalid_attrs)
      assert "can't be blank" in errors_on(changeset).name
      assert "can't be blank" in errors_on(changeset).is_fixed
      assert "can't be blank" in errors_on(changeset).priority
      assert "can't be blank" in errors_on(changeset).machine_id
    end

    test "create/1 with name shorter than 20 characters and description returns error changeset" do
      machine = TestHelpers.create_machine()
      invalid_attrs = Map.put(@valid_attrs, :description, "some description")
      message = "name has to be longer than 20 characters for description to be allowed"

      assert {:error, changeset} = Failures.create(machine, invalid_attrs)
      assert message in errors_on(changeset).name
    end

    test "update/2 with valid data updates the failure" do
      failure = TestHelpers.create_failure()

      assert {:ok, %Failure{} = failure} = Failures.update(failure, @update_attrs)
      assert failure.description == nil
      assert failure.is_fixed == false
      assert failure.name == "some updated name"
      assert failure.priority == :high
    end

    test "update/2 with invalid data returns error changeset" do
      failure = TestHelpers.create_failure()

      assert {:error, %Ecto.Changeset{}} = Failures.update(failure, @invalid_attrs)
      assert failure == Failures.get!(failure.id)
    end

    test "delete/1 deletes the failure" do
      failure = TestHelpers.create_failure()

      assert {:ok, %Failure{}} = Failures.delete(failure)
      assert_raise Ecto.NoResultsError, fn -> Failures.get!(failure.id) end
    end

    test "change/1 returns a failure changeset" do
      failure = TestHelpers.create_failure()

      assert %Ecto.Changeset{} = Failures.change(failure)
    end
  end
end
