defmodule VanadoBackendWeb.FailureView do
  use VanadoBackendWeb, :view
  alias VanadoBackendWeb.FailureView

  def render("index.json", %{failures: failures}) do
    %{data: render_many(failures, FailureView, "failure.json")}
  end

  def render("show.json", %{failure: failure}) do
    %{data: render_one(failure, FailureView, "failure.json")}
  end

  def render("failure.json", %{failure: failure}) do
    %{
      id: failure.id,
      name: failure.name,
      description: failure.description,
      is_fixed: failure.is_fixed,
      priority: failure.priority
    }
  end
end
