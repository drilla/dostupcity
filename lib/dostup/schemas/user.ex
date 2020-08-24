defmodule Dostup.Schemas.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Dostup.Services.Password
  alias Dostup.Schemas.District

  use Dostup.Services.Serializer.Fields, %{
    id: [:list, :show],
    age: [:show, :list],
    email: [:show, :list],
    fio: [:list, :show],
    inserted_at: [:list, :show],
    district: [:list, :show]
  }

  schema "users" do
    field(:password_hash, :string, size: 32)
    field(:password, :string, size: 100, virtual: true)
    field(:login, :string, virtual: true)
    field(:email, :string, size: 64)
    field(:fio, :string, size: 255)
    field(:age, :integer, size: 255)
    timestamps(updated_at: false, type: :utc_datetime)
    belongs_to(:district, District)
  end

  @spec changeset(Ecto.Changeset.t() | map(), map()) :: Ecto.Changeset.t()
  def changeset(model, params) do
    model
    |> cast(params, [:email, :fio, :age])
    |> validate_required([:email, :fio, :age])
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
  end

  def registration_changeset(params) do
    %__MODULE__{}
    |> cast(params, [:password, :login, :fio, :age, :district_id])
    |> validate_required([:password, :login, :fio, :age, :district_id])
    |> validate_length(:password, min: 8, max: 100)
    |> put_login()
    |> put_password_hash()
  end

  def update_password_changeset(user, password) do
    user
    |> change(%{password: password})
    |> put_password_hash()
  end

  defp put_password_hash(changeset) do
    if changeset.valid? do
      pass = fetch_change!(changeset, :password)
      put_change(changeset, :password_hash, Password.hash(pass))
    else
      changeset
    end
  end

  defp put_login(changeset) do
    if changeset.valid? do
      login = fetch_change!(changeset, :login)
      put_change(changeset, :email, login)
    else
      changeset
    end
  end
end
