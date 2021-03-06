defmodule VanadoBackendWeb.FileView do
  use VanadoBackendWeb, :view
  alias VanadoBackendWeb.FileView

  def render("index.json", %{files: files}) do
    %{data: render_many(files, FileView, "file.json")}
  end

  def render("file.json", %{file: file}) do
    %{id: file.id, name: file.name, type: file.type, failure_id: file.failure_id}
  end
end
