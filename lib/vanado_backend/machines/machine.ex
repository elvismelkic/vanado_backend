defmodule VanadoBackend.Machines.Machine do
  use Ecto.Schema
  import Ecto.Changeset
  alias VanadoBackend.Failures.Failure

  schema "machines" do
    field :name, :string

    has_many :failures, Failure

    timestamps()
  end

  @doc false
  def changeset(machine, attrs) do
    machine
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
