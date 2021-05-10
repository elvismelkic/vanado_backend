defmodule VanadoBackend.Files.File do
  use Ecto.Schema
  import Ecto.Changeset
  alias VanadoBackend.Failures.Failure

  schema "files" do
    field :name, :string
    field :type, :string

    belongs_to :failure, Failure

    timestamps()
  end

  @doc false
  def changeset(file, attrs) do
    file
    |> cast(attrs, [:name, :type])
    |> validate_required([:name, :type])
  end
end
