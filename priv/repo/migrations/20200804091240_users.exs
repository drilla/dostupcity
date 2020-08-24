defmodule Dostup.Persistence.Repo.Migrations.Users do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :fio, :string, size: 255, null: false
      add :password_hash, :string, size: 32, null: false
      add :age, :int, null: true
      add :email, :string, size: 255, null: false
      timestamps(updated_at: false, type: :utc_datetime)
    end
  end
end
