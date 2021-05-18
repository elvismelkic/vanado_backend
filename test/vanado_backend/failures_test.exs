defmodule VanadoBackend.FailuresTest do
  use VanadoBackend.DataCase

  import Mox

  alias VanadoBackend.Failures

  describe "failures" do
    alias VanadoBackend.Failures.Failure
    alias VanadoBackend.Files.File
    alias VanadoBackend.Repo

    @valid_attrs %{description: nil, is_fixed: true, name: "some name", priority: :moderate}
    @update_attrs %{description: nil, is_fixed: false, name: "some updated name", priority: :high}
    @invalid_attrs %{description: nil, is_fixed: nil, name: nil, priority: nil, machine_id: nil}

    test "list/0 returns all failures" do
      failure = TestHelpers.create_failure_with_machine()

      assert Failures.list() == [failure]
    end

    test "get!/1 returns the failure with given id" do
      failure = TestHelpers.create_failure()

      assert Failures.get!(failure.id) == failure
    end

    test "create/1 with valid data creates a failure" do
      {machine, valid_attrs} = machine_and_valid_attrs()

      assert {:ok, %Failure{} = failure} = Failures.create(valid_attrs)
      assert failure.description == nil
      assert failure.is_fixed == true
      assert failure.name == "some name"
      assert failure.priority == :moderate
      assert failure.machine_id == machine.id
    end

    test "create/1 with name longer than 20 characters and description creates a failure" do
      name_and_desc = %{
        name: "some extra long name with more than 20 characters",
        description: "some description"
      }

      valid_attrs = Map.merge(valid_attrs(), name_and_desc)

      assert {:ok, %Failure{} = failure} = Failures.create(valid_attrs)
      assert failure.description == "some description"
      assert failure.name == "some extra long name with more than 20 characters"
    end

    test "create/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{} = changeset} = Failures.create(@invalid_attrs)
      assert "can't be blank" in errors_on(changeset).name
      assert "can't be blank" in errors_on(changeset).is_fixed
      assert "can't be blank" in errors_on(changeset).priority
      assert "can't be blank" in errors_on(changeset).machine_id
    end

    test "create/1 with name shorter than 20 characters and description returns error changeset" do
      invalid_attrs = Map.put(valid_attrs(), :description, "some description")
      message = "name has to be longer than 20 characters for description to be allowed"

      assert {:error, changeset} = Failures.create(invalid_attrs)
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

    test "failure's files are deleted when failure is deleted" do
      stub(VanadoBackend.Api.MockFile, :create_folder_with_parents!, fn _path -> :ok end)
      stub(VanadoBackend.Api.MockFile, :create_file!, fn _source, _destination -> :ok end)
      stub(VanadoBackend.Api.MockFile, :delete_file!, fn _path -> :ok end)

      failure = TestHelpers.create_failure_with_file()

      assert Repo.all(File) != []

      Failures.delete(failure)

      assert Repo.all(File) == []
    end

    test "change/1 returns a failure changeset" do
      failure = TestHelpers.create_failure()

      assert %Ecto.Changeset{} = Failures.change(failure)
    end
  end

  defp valid_attrs do
    {_machine, valid_attrs} = machine_and_valid_attrs()

    valid_attrs
  end

  defp machine_and_valid_attrs do
    machine = TestHelpers.create_machine()
    valid_attrs = Map.put(@valid_attrs, :machine_id, machine.id)

    {machine, valid_attrs}
  end
end
