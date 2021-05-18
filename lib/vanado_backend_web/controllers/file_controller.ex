defmodule VanadoBackendWeb.FileController do
  use VanadoBackendWeb, :controller

  alias VanadoBackend.Files

  action_fallback VanadoBackendWeb.FallbackController

  def create(conn, params) do
    file_params = generate_file_params(params)

    with {:ok, files} <- Files.create(file_params) do
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

  defp generate_file_params(%{"files" => files, "failure" => failure_id}) do
    files
    |> Map.from_struct()
    |> Map.new(&rename_keys/1)
    |> Map.merge(%{failure_id: failure_id})
  end

  defp rename_keys({:filename, value}), do: {:name, value}
  defp rename_keys({:content_type, value}), do: {:type, value}
  defp rename_keys(pair), do: pair
end
