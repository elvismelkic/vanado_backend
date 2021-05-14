defmodule VanadoBackendWeb.FileController do
  use VanadoBackendWeb, :controller

  alias VanadoBackend.Files
  alias VanadoBackend.Files.File

  action_fallback VanadoBackendWeb.FallbackController

  def create(conn, params) do
    with {:ok, %File{} = file} <- Files.create(params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.file_path(conn, :show, file))
      |> render("show.json", file: file)
    end
  end

  def delete(conn, %{"id" => id}) do
    file = Files.get!(id)

    with {:ok, %File{}} <- Files.delete(file) do
      send_resp(conn, :no_content, "")
    end
  end
end
