defmodule VanadoBackend.Machines.Machine do
  use Ecto.Schema
  import Ecto.Changeset
  alias VanadoBackend.Failures.Failure

  @allowed_types %{name: :string}
  @attrs ~w/name/a

  schema "machines" do
    field :name, :string

    has_many :failures, Failure

    timestamps()
  end

  @doc false
  def changeset(machine, attrs) do
    machine
    |> cast(attrs, @attrs)
    |> validate_required(@attrs)
    |> unique_constraint(:name)
  end

  @doc false
  def validate(data) do
    {data, @allowed_types}
    |> cast(data, @attrs)
    |> validate_required(@attrs)
  end
end
