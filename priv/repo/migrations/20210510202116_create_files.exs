defmodule VanadoBackend.Repo.Migrations.CreateFiles do
  use Ecto.Migration

  def change do
    create table(:files) do
      add :name, :string, null: false
      add :type, :string, null: false
      add :failure_id, references(:failures, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:files, [:failure_id])
    create unique_index(:files, [:name, :failure_id])
  end
end
