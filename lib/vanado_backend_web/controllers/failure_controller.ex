defmodule VanadoBackendWeb.FailureController do
  use VanadoBackendWeb, :controller

  alias VanadoBackend.Failures
  alias VanadoBackend.Failures.Failure

  action_fallback VanadoBackendWeb.FallbackController

  def index(conn, _params) do
    is_fixed = Map.get(conn.query_params, "fixed")

    failures = Failures.list(is_fixed)
    render(conn, "index.json", failures: failures)
  end

  def create(conn, %{"failure" => failure_params}) do
    with {:ok, %Failure{} = failure} <- Failures.create(failure_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.failure_path(conn, :show, failure))
      |> render("show.json", failure: failure)
    end
  end

  def show(conn, %{"id" => id}) do
    failure = Failures.get!(id)
    render(conn, "show.json", failure: failure)
  end

  def update(%Plug.Conn{method: "PATCH"} = conn, %{"id" => id}) do
    failure = Failures.get!(id)

    with {:ok, %Failure{} = failure} <-
           Failures.update(failure, %{is_fixed: !failure.is_fixed}) do
      render(conn, "show.json", failure: failure)
    end
  end

  def update(conn, %{"id" => id, "failure" => failure_params}) do
    failure = Failures.get!(id)

    with {:ok, %Failure{} = failure} <- Failures.update(failure, failure_params) do
      render(conn, "show.json", failure: failure)
    end
  end

  def delete(conn, %{"id" => id}) do
    failure = Failures.get!(id)

    with {:ok, %Failure{}} <- Failures.delete(failure) do
      send_resp(conn, :no_content, "")
    end
  end
end