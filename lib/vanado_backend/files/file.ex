defmodule VanadoBackend.Files.File do
  use Ecto.Schema
  import Ecto.Changeset
  alias VanadoBackend.Failures.Failure

  @allowed_types %{name: :string, type: :string, path: :string, failure_id: :integer}
  @validation_attrs ~w/name type path failure_id/a
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

  @doc false
  def validate(data) do
    {data, @allowed_types}
    |> cast(data, @validation_attrs)
    |> validate_required(@validation_attrs)
  end
end
