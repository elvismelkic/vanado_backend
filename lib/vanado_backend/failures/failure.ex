defmodule VanadoBackend.Failures.Failure do
  use Ecto.Schema
  import Ecto.Changeset
  import EctoEnum
  alias VanadoBackend.Files.File
  alias VanadoBackend.Machines.Machine

  @allowed_types %{
    name: :string,
    description: :string,
    is_fixed: :boolean,
    priority: :string,
    machine_id: :int
  }

  defenum(PriorityEnum, :priority, [:low, :moderate, :high])

  schema "failures" do
    field :name, :string
    field :description, :string
    field :is_fixed, :boolean, default: false
    field :priority, PriorityEnum

    belongs_to :machine, Machine
    has_many :files, File

    timestamps()
  end

  @attrs ~w/name description is_fixed priority machine_id/a
  @required_attrs ~w/name is_fixed priority machine_id/a

  @doc false
  def changeset(failure, attrs) do
    failure
    |> cast(attrs, @attrs)
    |> validate_required(@required_attrs)
    |> check_constraint(:name,
      name: :name_longer_than_20_for_description,
      message: "name has to be longer than 20 characters for description to be allowed"
    )
  end

  @doc false
  def validate(data) do
    {data, @allowed_types}
    |> cast(data, @attrs)
    |> validate_required(@required_attrs)
  end
end
