defmodule VanadoBackend.FilesTest do
  use VanadoBackend.DataCase

  alias VanadoBackend.Files

  describe "files" do
    alias VanadoBackend.Files.File

    @valid_attrs %{name: "some name", type: "some type"}
    @invalid_attrs %{name: nil, type: nil}

    def file_fixture(attrs \\ %{}) do
      {:ok, file} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Files.create()

      file
    end

    test "create/1 with valid data creates a file" do
      assert {:ok, %File{} = file} = Files.create(@valid_attrs)
      assert file.name == "some name"
      assert file.type == "some type"
    end

    test "create/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Files.create(@invalid_attrs)
    end

    test "delete/1 deletes the file" do
      file = file_fixture()
      assert {:ok, files} = Files.delete(file.id)
      assert files == []
    end

    test "change_file/1 returns a file changeset" do
      file = file_fixture()
      assert %Ecto.Changeset{} = Files.change(file)
    end
  end
end
