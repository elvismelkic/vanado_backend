defmodule VanadoBackendWeb.FileController do
  use VanadoBackendWeb, :controller

  alias VanadoBackend.Files

  action_fallback VanadoBackendWeb.FallbackController

  def create(conn, params) do
    with {:ok, files} <- Files.create(params) do
      conn
      |> put_status(:created)
      |> render("index.json", files: files)
    end
  end

  def delete(conn, %{"id" => id}) do
    with {:ok, files} <- Files.delete(id) do
      conn
      |> put_status(:ok)
      |> render("index.json", files: files)
    end
  end
end
