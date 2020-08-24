defmodule Dostup.Persistence.Repo.Migrations.District do
  use Ecto.Migration

  def change do
    create table(:districts) do
      add :name, :string, size: 255, null: false
      add :city_id, references(:cities)
    end

    create unique_index(:districts, [:city_id, :name])

  end
end
