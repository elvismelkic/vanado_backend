defmodule VanadoBackendWeb.FailureControllerTest do
  use VanadoBackendWeb.ConnCase

  alias VanadoBackend.Failures
  alias VanadoBackend.Failures.Failure

  @create_attrs %{
    description: "some description",
    is_fixed: true,
    name: "some name"
  }
  @update_attrs %{
    description: "some updated description",
    is_fixed: false,
    name: "some updated name"
  }
  @invalid_attrs %{description: nil, is_fixed: nil, name: nil}

  def fixture(:failure) do
    {:ok, failure} = Failures.create_failure(@create_attrs)
    failure
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all failures", %{conn: conn} do
      conn = get(conn, Routes.failure_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create failure" do
    test "renders failure when data is valid", %{conn: conn} do
      conn = post(conn, Routes.failure_path(conn, :create), failure: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.failure_path(conn, :show, id))

      assert %{
               "id" => id,
               "description" => "some description",
               "is_fixed" => true,
               "name" => "some name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.failure_path(conn, :create), failure: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update failure" do
    setup [:create_failure]

    test "renders failure when data is valid", %{conn: conn, failure: %Failure{id: id} = failure} do
      conn = put(conn, Routes.failure_path(conn, :update, failure), failure: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.failure_path(conn, :show, id))

      assert %{
               "id" => id,
               "description" => "some updated description",
               "is_fixed" => false,
               "name" => "some updated name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, failure: failure} do
      conn = put(conn, Routes.failure_path(conn, :update, failure), failure: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete failure" do
    setup [:create_failure]

    test "deletes chosen failure", %{conn: conn, failure: failure} do
      conn = delete(conn, Routes.failure_path(conn, :delete, failure))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.failure_path(conn, :show, failure))
      end
    end
  end

  defp create_failure(_) do
    failure = fixture(:failure)
    %{failure: failure}
  end
end
