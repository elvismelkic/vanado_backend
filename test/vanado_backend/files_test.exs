defmodule VanadoBackend.FilesTest do
  use VanadoBackend.DataCase

  import Mox

  alias VanadoBackend.Files
  alias VanadoBackend.Repo

  describe "files" do
    alias VanadoBackend.Files.File

    @valid_attrs %{name: "some name", type: "some type"}
    @invalid_attrs %{name: nil, type: nil}

    test "create/1 with valid data creates a file" do
      stub(VanadoBackend.Api.MockFile, :create_folder_with_parents!, fn _path -> :ok end)
      stub(VanadoBackend.Api.MockFile, :create_file!, fn _source, _destination -> :ok end)

      {:ok, %File{} = file} = Files.create(@valid_attrs)
      db_file = Repo.get!(File, file.id)

      assert file == db_file
      assert file.name == "some name"
      assert file.type == "some type"
    end

    test "create/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Files.create(@invalid_attrs)
    end

    test "delete/1 deletes the file" do
      file = TestHelpers.create_file()

      assert {:ok, files} = Files.delete(file.id)
      assert files == []
    end

    test "change_file/1 returns a file changeset" do
      file = TestHelpers.create_file()

      assert %Ecto.Changeset{} = Files.change(file)
    end
  end
end
