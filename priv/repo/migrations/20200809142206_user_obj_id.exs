defmodule Dostup.Persistence.Repo.Migrations.UserObjId do
  use Ecto.Migration

  def change do
    alter table :objects do
      add :user_id, references :users
    end
  end
end
