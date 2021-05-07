defmodule VanadoBackendWeb.FailureController do
  use VanadoBackendWeb, :controller

  alias VanadoBackend.Failures
  alias VanadoBackend.Failures.Failure

  action_fallback VanadoBackendWeb.FallbackController

  def index(conn, _params) do
    is_fixed = Map.get(conn.query_params, "fixed")

    failures = Failures.list_failures(is_fixed)
    render(conn, "index.json", failures: failures)
  end

  def create(conn, %{"failure" => failure_params}) do
    with {:ok, %Failure{} = failure} <- Failures.create_failure(failure_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.failure_path(conn, :show, failure))
      |> render("show.json", failure: failure)
    end
  end

  def show(conn, %{"id" => id}) do
    failure = Failures.get_failure!(id)
    render(conn, "show.json", failure: failure)
  end

  def update(%Plug.Conn{method: "PATCH"} = conn, %{"id" => id}) do
    failure = Failures.get_failure!(id)

    with {:ok, %Failure{} = failure} <-
           Failures.update_failure(failure, %{is_fixed: !failure.is_fixed}) do
      render(conn, "show.json", failure: failure)
    end
  end

  def update(conn, %{"id" => id, "failure" => failure_params}) do
    failure = Failures.get_failure!(id)

    with {:ok, %Failure{} = failure} <- Failures.update_failure(failure, failure_params) do
      render(conn, "show.json", failure: failure)
    end
  end

  def delete(conn, %{"id" => id}) do
    failure = Failures.get_failure!(id)

    with {:ok, %Failure{}} <- Failures.delete_failure(failure) do
      send_resp(conn, :no_content, "")
    end
  end
end
