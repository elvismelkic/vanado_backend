defmodule VanadoBackendWeb.FileControllerTest do
  use VanadoBackendWeb.ConnCase

  import Mox

  @create_attrs %Plug.Upload{
    filename: "some name",
    content_type: "some type",
    path: "some/test/path"
  }
  @invalid_attrs %Plug.Upload{filename: nil, content_type: nil, path: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create file" do
    test "renders file when data is valid", %{conn: conn} do
      failure = TestHelpers.create_failure()
      attrs = %{"failure" => failure.id, "files" => @create_attrs}

      stub(VanadoBackend.Api.MockFile, :create_folder_with_parents!, fn _path -> :ok end)
      stub(VanadoBackend.Api.MockFile, :create_file!, fn _source, _destination -> :ok end)

      conn = post(conn, Routes.file_path(conn, :create), attrs)

      assert [file] = json_response(conn, 201)["data"]
      assert file["name"] == "some name"
      assert file["type"] == "some type"
      assert file["failureId"] == failure.id
    end

    test "renders errors when data is invalid", %{conn: conn} do
      attrs = %{"failure" => 999_999, "files" => @invalid_attrs}
      conn = post(conn, Routes.file_path(conn, :create), attrs)

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete file" do
    setup [:create_file]

    test "deletes chosen file", %{conn: conn, test_file: file} do
      conn = delete(conn, Routes.file_path(conn, :delete, file))
      assert json_response(conn, 200)["data"] == []
    end
  end

  defp create_file(_) do
    stub_file_api()

    file = TestHelpers.create_file()
    %{test_file: file}
  end

  defp stub_file_api do
    stub(VanadoBackend.Api.MockFile, :create_folder_with_parents!, fn _path -> :ok end)
    stub(VanadoBackend.Api.MockFile, :create_file!, fn _source, _destination -> :ok end)
    stub(VanadoBackend.Api.MockFile, :delete_file!, fn _path -> :ok end)
  end
end
