defmodule Dostup.Persistence.Repo.Migrations.DistUser do
  use Ecto.Migration

  def change do
    alter table :users do
      add :district_id, references :districts
    end
  end
end
