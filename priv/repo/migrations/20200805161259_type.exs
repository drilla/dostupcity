defmodule Dostup.Persistence.Repo.Migrations.Type do
  use Ecto.Migration

  def change do
    create table(:object_types) do
      add :name, :string, size: 255, null: false
    end

    create unique_index(:object_types, [:name])
  end
end
