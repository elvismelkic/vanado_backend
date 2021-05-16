defmodule VanadoBackendWeb.FileControllerTest do
  use VanadoBackendWeb.ConnCase

  alias VanadoBackend.Files
  alias VanadoBackend.Files.File

  @create_attrs %{
    filename: "some name",
    content_type: "some type",
    path: "some/test/path"
  }
  @invalid_attrs %{name: nil, type: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create file" do
    test "renders file when data is valid", %{conn: conn} do
      failure = TestHelpers.create_failure()
      attrs = %{"failure" => failure.id, "files" => @create_attrs}

      conn = post(conn, Routes.file_path(conn, :create), attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.file_path(conn, :show, id))

      assert %{
               "id" => id,
               "name" => "some name",
               "type" => "some type"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.file_path(conn, :create), file: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete file" do
    setup [:create_file]

    test "deletes chosen file", %{conn: conn, file: file} do
      conn = delete(conn, Routes.file_path(conn, :delete, file))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.file_path(conn, :show, file))
      end
    end
  end

  defp create_file(_) do
    file = TestHelpers.create_file()
    %{file: file}
  end
end
