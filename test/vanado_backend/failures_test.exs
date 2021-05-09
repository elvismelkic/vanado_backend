defmodule VanadoBackend.FailuresTest do
  use VanadoBackend.DataCase

  alias VanadoBackend.Failures

  describe "failures" do
    alias VanadoBackend.Failures.Failure

    @valid_attrs %{description: "some description", is_fixed: true, name: "some name"}
    @update_attrs %{
      description: "some updated description",
      is_fixed: false,
      name: "some updated name"
    }
    @invalid_attrs %{description: nil, is_fixed: nil, name: nil}

    def failure_fixture(attrs \\ %{}) do
      {:ok, failure} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Failures.create()

      failure
    end

    test "list/0 returns all failures" do
      failure = failure_fixture()
      assert Failures.list() == [failure]
    end

    test "get!/1 returns the failure with given id" do
      failure = failure_fixture()
      assert Failures.get!(failure.id) == failure
    end

    test "create/1 with valid data creates a failure" do
      assert {:ok, %Failure{} = failure} = Failures.create(@valid_attrs)
      assert failure.description == "some description"
      assert failure.is_fixed == true
      assert failure.name == "some name"
    end

    test "create/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Failures.create(@invalid_attrs)
    end

    test "update/2 with valid data updates the failure" do
      failure = failure_fixture()
      assert {:ok, %Failure{} = failure} = Failures.update(failure, @update_attrs)
      assert failure.description == "some updated description"
      assert failure.is_fixed == false
      assert failure.name == "some updated name"
    end

    test "update/2 with invalid data returns error changeset" do
      failure = failure_fixture()
      assert {:error, %Ecto.Changeset{}} = Failures.update(failure, @invalid_attrs)
      assert failure == Failures.get!(failure.id)
    end

    test "delete/1 deletes the failure" do
      failure = failure_fixture()
      assert {:ok, %Failure{}} = Failures.delete(failure)
      assert_raise Ecto.NoResultsError, fn -> Failures.get!(failure.id) end
    end

    test "change/1 returns a failure changeset" do
      failure = failure_fixture()
      assert %Ecto.Changeset{} = Failures.change(failure)
    end
  end
end
