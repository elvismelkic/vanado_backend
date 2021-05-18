defmodule VanadoBackend.FilesTest do
  use VanadoBackend.DataCase

  import Mox

  alias VanadoBackend.Files
  alias VanadoBackend.Repo

  describe "files" do
    alias VanadoBackend.Files.File

    @valid_attrs %{name: "some name", type: "some type", path: "some/test/path"}
    @invalid_attrs %{name: nil, type: nil, path: nil, failure_id: nil}

    test "create/1 with valid data creates a file" do
      failure = TestHelpers.create_failure()
      attrs = Map.put(@valid_attrs, :failure_id, failure.id)

      stub(VanadoBackend.Api.MockFile, :create_folder_with_parents!, fn _path -> :ok end)
      stub(VanadoBackend.Api.MockFile, :create_file!, fn _source, _destination -> :ok end)

      assert {:ok, [file]} = Files.create(attrs)

      db_file = Repo.get!(File, file.id)

      assert db_file.name == "some name"
      assert db_file.type == "some type"
    end

    test "create/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{} = changeset} = Files.create(@invalid_attrs)
      assert "can't be blank" in errors_on(changeset).name
      assert "can't be blank" in errors_on(changeset).type
      assert "can't be blank" in errors_on(changeset).failure_id
    end

    test "delete/1 deletes the file" do
      file = TestHelpers.create_file()

      stub(VanadoBackend.Api.MockFile, :delete_file!, fn _path -> :ok end)

      assert {:ok, files} = Files.delete(file.id)
      assert files == []
    end

    test "change_file/1 returns a file changeset" do
      file = TestHelpers.create_file()

      assert %Ecto.Changeset{} = Files.change(file)
    end
  end
end
