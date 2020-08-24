defmodule Dostup.Persistence.Repo.Migrations.UserDistrict do
  use Ecto.Migration

  def change do

    create table "users_districts" do
      add :user_id, references(:users)
      add :district_id, references(:districts)
    end

    create unique_index(:users_districts, [:user_id, :district_id])
  end
end
