defmodule VanadoBackend.Repo.Migrations.CreateMachines do
  use Ecto.Migration

  def change do
    create table(:machines) do
      add :name, :string

      timestamps()
    end

    create unique_index(:machines, [:name])
  end
end
