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
    |> cast(attrs, [:name, :type, :failure_id])
    |> validate_required([:name, :type, :failure_id])
    |> unique_constraint([:name, :failure_id])
  end
end
