defmodule Dostup.Persistence.Repo.Migrations.City do
  use Ecto.Migration

  def change do
    create table(:cities) do
      add :name, :string, size: 255, null: false
    end

    create unique_index(:cities, [ :name])

  end
end
