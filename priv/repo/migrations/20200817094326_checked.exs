defmodule Dostup.Persistence.Repo.Migrations.Checked do
  use Ecto.Migration

  def change do
    alter table :objects do
      add :is_checked, :boolean, null: false, default: false
    end
  end
end
