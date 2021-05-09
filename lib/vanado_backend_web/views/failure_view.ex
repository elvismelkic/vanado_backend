defmodule VanadoBackendWeb.FailureView do
  use VanadoBackendWeb, :view
  alias VanadoBackendWeb.FailureView

  def render("index.json", %{failures: failures}) do
    %{data: render_many(failures, FailureView, "failure_with_machine.json")}
  end

  def render("show.json", %{failure: failure}) do
    %{data: render_one(failure, FailureView, "failure.json")}
  end

  def render("failure.json", %{failure: failure}) do
    failure_basic_fields(failure)
  end

  def render("failure_with_machine.json", %{failure: failure}) do
    failure
    |> failure_basic_fields()
    |> Map.merge(%{machine: failure.machine})
  end

  defp failure_basic_fields(failure) do
    %{
      id: failure.id,
      name: failure.name,
      description: failure.description,
      is_fixed: failure.is_fixed,
      priority: failure.priority
    }
  end
end
