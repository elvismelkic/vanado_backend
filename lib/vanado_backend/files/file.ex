defmodule VanadoBackend.Files.File do
  use Ecto.Schema
  import Ecto.Changeset
  alias VanadoBackend.Failures.Failure

  @attrs ~w/name type failure_id/a

  schema "files" do
    field :name, :string
    field :type, :string

    belongs_to :failure, Failure

    timestamps()
  end

  @doc false
  def changeset(file, attrs) do
    file
    |> cast(attrs, @attrs)
    |> validate_required(@attrs)
    |> unique_constraint([:name, :failure_id])
  end
end
