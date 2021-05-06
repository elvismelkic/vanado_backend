defmodule VanadoBackend.FailuresTest do
  use VanadoBackend.DataCase

  alias VanadoBackend.Failures

  describe "failures" do
    alias VanadoBackend.Failures.Failure

    @valid_attrs %{description: "some description", is_fixed: true, name: "some name"}
    @update_attrs %{description: "some updated description", is_fixed: false, name: "some updated name"}
    @invalid_attrs %{description: nil, is_fixed: nil, name: nil}

    def failure_fixture(attrs \\ %{}) do
      {:ok, failure} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Failures.create_failure()

      failure
    end

    test "list_failures/0 returns all failures" do
      failure = failure_fixture()
      assert Failures.list_failures() == [failure]
    end

    test "get_failure!/1 returns the failure with given id" do
      failure = failure_fixture()
      assert Failures.get_failure!(failure.id) == failure
    end

    test "create_failure/1 with valid data creates a failure" do
      assert {:ok, %Failure{} = failure} = Failures.create_failure(@valid_attrs)
      assert failure.description == "some description"
      assert failure.is_fixed == true
      assert failure.name == "some name"
    end

    test "create_failure/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Failures.create_failure(@invalid_attrs)
    end

    test "update_failure/2 with valid data updates the failure" do
      failure = failure_fixture()
      assert {:ok, %Failure{} = failure} = Failures.update_failure(failure, @update_attrs)
      assert failure.description == "some updated description"
      assert failure.is_fixed == false
      assert failure.name == "some updated name"
    end

    test "update_failure/2 with invalid data returns error changeset" do
      failure = failure_fixture()
      assert {:error, %Ecto.Changeset{}} = Failures.update_failure(failure, @invalid_attrs)
      assert failure == Failures.get_failure!(failure.id)
    end

    test "delete_failure/1 deletes the failure" do
      failure = failure_fixture()
      assert {:ok, %Failure{}} = Failures.delete_failure(failure)
      assert_raise Ecto.NoResultsError, fn -> Failures.get_failure!(failure.id) end
    end

    test "change_failure/1 returns a failure changeset" do
      failure = failure_fixture()
      assert %Ecto.Changeset{} = Failures.change_failure(failure)
    end
  end
end
