defmodule Dostup.Persistence.Repo.Migrations.Obj do
  use Ecto.Migration

  def change do
    create table(:objects) do
      add :name, :string, size: 255, null: false
      add :short_name, :string, size: 255, null: false
      add :address, :string, size: 255, null: false
      add :ymap_url, :string, size: 255, null: false

      add :district_id, references(:districts)
      add :type_id, references(:object_types)
    end


    create unique_index(:objects, [:district_id, :name, :address])
  end
end
