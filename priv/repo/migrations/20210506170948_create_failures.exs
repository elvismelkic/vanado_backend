defmodule VanadoBackend.Repo.Migrations.CreateFailures do
  use Ecto.Migration
  import EctoEnum

  defenum PriorityEnum, :priority, [:low, :moderate, :high]

  def change do
    PriorityEnum.create_type()

    create table(:failures) do
      add :name, :string, null: false
      add :description, :string
      add :is_fixed, :boolean, default: false, null: false
      add :machine_id, references(:machines, on_delete: :delete_all), null: false
      add :priority, PriorityEnum.type(), null: false

      timestamps()
    end

    create index(:failures, [:machine_id])

    create constraint(:machines, :name_not_empty, check: "char_length(name) > 0")
    create constraint(:failures, :name_not_empty, check: "char_length(name) > 0")
    create constraint(:failures, :name_longer_than_20_for_description, check: "char_length(name) > 20 OR description IS NULL")
  end
end
